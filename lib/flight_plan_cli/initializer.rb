require 'thor'
require 'colorize'
require 'rugged'

module FlightPlanCli
  class ApiUnauthorized < StandardError; end
  class ApiNotFound < StandardError; end

  class Initializer < Thor
    YAML_FILE = '.flight_plan_cli.yml'.freeze

    def initialize(*args)
      read_config
      super
    end

    desc 'ls', 'List open issues'
    def ls
      swimlanes = tickets_by_swimlane
      default_swimlane_ids.each do |swimlane_id|
        next unless swimlanes.key?(swimlane_id)

        print_swimlane(swimlanes[swimlane_id])
      end
    rescue ApiUnauthorized
      puts 'Unauthorize. Please ensure your key and secret as setup correctly'.red
    rescue Errno::ECONNREFUSED, SocketError => e
      # TODO: caching - low timeout (5s) then fallback to cache
      puts "Network error. #{e.message}".red
    end

    desc 'checkout ISSUE_NO', 'checkout a branch for ISSUE_NO'
    def checkout(issue_no)
      puts "Checking out branch for #{issue_no}"
      local_branch_for(issue_no) || remote_branch_for(issue_no)
    rescue Rugged::CheckoutError => e
      puts "Unable to checkout: #{e.message}".red
    end

    map co: :checkout

    private

    attr_reader :board_id, :repo_id, :default_swimlane_ids
    attr_reader :api_url, :api_key, :api_secret

    def read_config
      @board_id = config['board_id']
      @repo_id = config['repo_id']
      @default_swimlane_ids = config['ls']['default_swimlane_ids']

      @api_url = config['api_url']
      @api_key = ENV['FLIGHT_PLAN_API_KEY']
      @api_secret = ENV['FLIGHT_PLAN_API_SECRET']
    end

    def local_branch_for(issue)
      issue_branches = local_branches.map(&:name).grep(/##{issue}[^0-9]/)
      return false unless issue_branches.count == 1

      branch = issue_branches.first
      puts "Checking out local branch '#{branch}'".green
      git.checkout(branch)
      true
    end

    def remote_branch_for(issue)
      git.fetch('origin')
      issue_branches = remote_branches.map(&:name).grep(/##{issue}[^0-9]/)
      return false unless issue_branches.count == 1

      remote_branch_name = issue_branches.first
      branch = remote_branches.find { |rb| rb.name == remote_branch_name }
      local_name = branch.name[branch.remote_name.size + 1..-1]

      puts "Checking out and tracking remote branch '#{local_name}'".green
      new_branch = git.branches.create(local_name, branch.name)
      new_branch.upstream = branch
      git.checkout(local_name)
      true
    end

    def local_branches
      @local_branches ||= git.branches.each(:local)
    end

    def remote_branches
      @remote_branches ||= git.branches.each(:remote)
    end

    def git
      @git ||= Rugged::Repository.new(Dir.pwd)
    end

    def fetch
      puts 'fetching...'
      git.remotes.each(&:fetch)
    end

    def print_swimlane(swimlane)
      puts "#{swimlane['name']} (#{swimlane['tickets'].count})".green
      swimlane['tickets'].each do |ticket|
        puts "├── #{ticket['remote_number'].rjust(4)} : #{ticket['remote_title']}".yellow
      end
    end

    def tickets_by_swimlane
      response = client.board_tickets(board_id: board_id, repo_id: repo_id)
      raise ApiUnauthorized if response.code == 401
      raise ApiNotFound if response.code == 404

      swimlanes = {}
      response.each do |board_ticket|
        swimlane = board_ticket['swimlane']
        next unless default_swimlane_ids.include? swimlane['id']

        swimlanes[swimlane['id']] ||= swimlane
        swimlanes[swimlane['id']]['tickets'] ||= []
        swimlanes[swimlane['id']]['tickets'] << board_ticket['ticket']
      end
      swimlanes
    end

    def config
      @config ||=
        begin
          unless File.exist?(YAML_FILE)
            puts "Could not file #{YAML_FILE} file."
            exit 1
          end
          YAML.load_file(YAML_FILE)
        end
    end

    def client
      @client ||= FlightPlanCli::Api.new(
        url: api_url,
        key: api_key,
        secret: api_secret
      )
    end
  end
end
