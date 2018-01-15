module FlightPlanCli
  module Commands
    class Checkout
      def process(issue_no)
        puts "Checking out branch for #{issue_no}"
        local_branch_for(issue_no) ||
          remote_branch_for(issue_no) ||
          new_branch_for(issue_no)
      rescue Rugged::CheckoutError => e
        puts "Unable to checkout: #{e.message}".red
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
        fetch
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
        puts 'Fetching...'.green
        git.remotes.each {|remote| remote.fetch(credentials: ssh_agent) }
      end

      def ssh_agent
        @ssh_agent ||= Rugged::Credentials::SshKeyFromAgent.new(username: 'git')
      end
    end
  end
end
