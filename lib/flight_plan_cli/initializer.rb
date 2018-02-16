
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
      Commands::List.new.process
    end

    desc 'checkout ISSUE_NO', 'checkout a branch for ISSUE_NO'
    def checkout(issue_no)
      Commands::Checkout.new.process(issue_no)
    end

    map co: :checkout
  end
end
