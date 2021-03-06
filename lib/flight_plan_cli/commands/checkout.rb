module FlightPlanCli
  module Commands
    class Checkout
      include FlightPlanCli::Clients::Git
      include FlightPlanCli::Clients::FlightPlan

      def initialize(issue_no, options)
        @issue_no = issue_no
        @base_branch = options["base"]
        @branch_prefix = options["prefix"]
        @fetched = false
      end

      def process
        local_branch_for_issue || remote_branch_for_issue || new_branch_for_issue
      rescue Git::GitExecuteError => e
        puts 'Unable to checkout'.red
        puts e.message.yellow
      end

      private

      attr_reader :issue_no, :base_branch, :branch_prefix

      def local_branch_for_issue
        issue_branches = local_branches.map(&:name).grep(/##{issue_no}[^0-9]/)
        return false unless issue_branches.count == 1

        branch = issue_branches.first
        puts "Checking out local branch '#{branch}'".green
        git.checkout(branch)
        true
      end

      def remote_branch_for_issue
        issue_branches = remote_branches.map(&:name).grep(/##{issue_no}[^0-9]/)
        return false unless issue_branches.count == 1

        remote_branch_name = issue_branches.first
        branch = remote_branches.find { |rb| rb.name == remote_branch_name }

        puts "Checking out and tracking remote branch '#{branch.name}'".green
        git.checkout(branch.name)
        true
      end

      def new_branch_for_issue
        branches = flight_plan.board_tickets(remote_number: issue_no)
        # TODO: update flight_plan to only return one issue when remote_numer is provided
        branches = branches.select { |b| b['ticket']['remote_number'] == issue_no }
        return false unless branches.count == 1

        branch_name = branch_name(branches.first)
        git.checkout(base_branch)
        git.pull
        puts "Creating new branch #{branch_name} from #{base_branch}".green
        git.branch(branch_name).checkout
      end

      def branch_name(branch)
        "#{branch_prefix}/##{branch['ticket']['remote_number']}-" +
          branch['ticket']['remote_title']
            .gsub(/\([^)]*\)/, '') # remove everything inside brackets
            .match(/^.{0,60}\b/)[0] # take the first 60 chars (finish on word boundry)
            .gsub(/[^a-z0-9_\-\s]/i, '') # remove everything except alpha-numeric, _ and -
            .squeeze(' ')
            .strip
            .tr('_ ', '-')
            .downcase
      end

      def local_branches
        @local_branches ||= git.branches.local
      end

      def remote_branches
        fetch
        @remote_branches ||= git.branches.remote
      end

      def fetch
        return if @fetched
        puts 'Fetching...'.green
        git.remote('origin').fetch
        @fetched = true
      end
    end
  end
end
