require 'thor'
require 'colorize'
require 'rugged'

module FlightPlanCli
  class ApiUnauthorized < StandardError; end
  class ApiNotFound < StandardError; end

  class Initializer < Thor
    include FlightPlanCli::Config

    def initialize(*args)
      read_config
      super
    end

    desc 'ls', 'List open issues'
    def ls
      Commands::Ls.new.process
    end

    desc 'checkout ISSUE_NO', 'checkout a branch for ISSUE_NO'
    def checkout(issue_no)
      puts "Checking out branch for #{issue_no}"
      local_branch_for(issue_no) ||
        remote_branch_for(issue_no) ||
        new_branch_for(issue_no)
    rescue Rugged::CheckoutError => e
      puts "Unable to checkout: #{e.message}".red
    end

    map co: :checkout

    private

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
      git.remotes.each {|remote| remote.fetch(credentials: ssh_agent) }
    end

    def ssh_agent
      @ssh_agent ||= Rugged::Credentials::SshKeyFromAgent.new(username: 'git')
    end



  end
end
