module FlightPlanCli
  module Commands
    class Ls
      include FlightPlanCli::Config

      def initialize
        read_config
      end

      def process
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

      def tickets_by_swimlane
        response = client.board_tickets(board_id: board_id, repo_id: repo_id)
        puts 'ok2'
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

      def print_swimlane(swimlane)
        puts "#{swimlane['name']} (#{swimlane['tickets'].count})".green
        swimlane['tickets'].each do |ticket|
          puts "├── #{ticket['remote_number'].rjust(4)} : #{ticket['remote_title']}".yellow
        end
      end
    end
  end
end
