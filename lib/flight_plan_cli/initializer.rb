module FlightPlanCli
  class ApiUnauthorized < StandardError; end
  class ApiNotFound < StandardError; end

  class Initializer < Thor
    desc 'ls', 'List open issues'
    def ls
      Commands::List.new.process
    end

    desc 'checkout ISSUE_NO', 'checkout a branch for ISSUE_NO'
    option :base, desc: 'base branch for the new branch', aliases: :b, default: 'master'
    option :prefix, desc: 'prefix for the new branch', aliases: :p, default: 'feature'
    def checkout(issue_no)
      Commands::Checkout.new(issue_no, options).process
    end

    desc 'release', 'create a release'
    def release
      Commands::Release.new.process
    end

    map co: :checkout

    desc 'config', 'Print current config'
    def config
      Commands::Config.new.process
    end
  end
end
