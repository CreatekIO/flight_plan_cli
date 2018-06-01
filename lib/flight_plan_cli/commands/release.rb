module FlightPlanCli
  module Commands
    class Release
      include FlightPlanCli::Clients::FlightPlan

      def process
        response = flight_plan.create_release
        unless response.code == 201
          puts "Failed to create a release (#{response.code})".red
          if response['errors'].present?
            response['errors'].each do |error|
              puts "error: #{error}".red
            end
          end
          return
        end

        release = response['release']
        repo_release = release['repo_releases'].first
        puts "Created #{repo_release['repo']['name']} release \"#{release['title']}\" with the following tickets:".green
        repo_release['board_tickets'].each do |board_ticket|
          ticket = board_ticket['ticket']
          puts "  ##{ticket['remote_number']} - #{ticket['remote_title']}".green
        end
      end
    end
  end
end
