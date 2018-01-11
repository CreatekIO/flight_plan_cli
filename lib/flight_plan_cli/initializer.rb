require 'thor'
require 'colorize'

module FlightPlanCli
  class Initializer < Thor
    YAML_FILE = '.flight_plan_cli.yml'.freeze

    def initialize(*args)
      parse_yaml
      super
    end

    desc 'ls', 'List open issues'
    def ls
      swimlanes = tickets_by_swimlane
      default_swimlanes.each do |swimlane_id|
        next unless swimlanes.key?(swimlane_id)

        swimlane = swimlanes[swimlane_id]
        puts "#{swimlane['id']} - #{swimlane['name']}/".green
        swimlane['tickets'].each do |ticket|
          puts "├── #{ticket['remote_number']} : #{ticket['remote_title']}".yellow
        end
      end
    rescue Errno::ECONNREFUSED, SocketError => e
      # TODO: caching - low timeout (5s) then fallback to cache
      puts "Network error - #{e.message}".red
    end

    private

    attr_reader :board_id, :default_swimlanes


    def parse_yaml
      unless File.exist?(YAML_FILE)
        puts "Could not file #{YAML_FILE} file."
        exit 1
      end
      config = YAML.load_file(YAML_FILE)

      @board_id = config['board_id']
      @default_swimlanes = config['ls']['default_swimlanes']
    end

    def tickets_by_swimlane
      response = api.board_tickets(board_id: board_id)

      board = response['board_tickets'].first['board']
      swimlanes = {}
      response['board_tickets'].each do |board_ticket|
        swimlane = board_ticket['swimlane']
        next unless default_swimlanes.include? swimlane['id']

        swimlanes[swimlane['id']] ||= swimlane
        swimlanes[swimlane['id']]['tickets'] ||= []
        swimlanes[swimlane['id']]['tickets'] << board_ticket['ticket']
      end
      board['swimlanes'] = swimlanes
    end

    def api
      @api ||= FlightPlanCli::Api.new(url: 'http://dev.createk.io/api', key: '', secret: '')
    end
  end
end
