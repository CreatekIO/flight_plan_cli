module FlightPlanCli
  class ApiUnauthorized < StandardError; end
  class ApiNotFound < StandardError; end

  class Initializer < Thor
    desc 'ls', 'List open issues'
    def ls
      Commands::List.new.process
    end

    desc 'checkout ISSUE_NO', 'checkout a branch for ISSUE_NO'
    def checkout(issue_no)
      Commands::Checkout.new(issue_no).process
    end

    map co: :checkout
  end
end
