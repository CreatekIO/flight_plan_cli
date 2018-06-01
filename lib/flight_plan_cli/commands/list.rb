module FlightPlanCli
  module Commands
    class List
      include FlightPlanCli::Clients::Git
      include FlightPlanCli::Clients::FlightPlan

      module Color
        SWIMLANE = :cyan
        ISSUE = :yellow
        ISSUE_NO = :light_red
        CHECKED_OUT_BACKGROUND = :light_black
      end

      def process
        swimlanes = tickets_by_swimlane
        FlightPlanCli.settings.default_swimlane_ids.each do |swimlane_id|
          next unless swimlanes.key?(swimlane_id)

          print_swimlane(swimlanes[swimlane_id])
        end
      rescue ApiUnauthorized
        puts 'Unauthorize. Please ensure your key and secret as setup correctly'.red
      rescue Errno::ECONNREFUSED, SocketError => e
        # TODO: caching - low timeout (5s) then fallback to cache
        puts "Network error. #{e.message}".red
      end

      private

      def tickets_by_swimlane
        response = flight_plan.board_tickets
        raise ApiUnauthorized if response.code == 401
        raise ApiNotFound if response.code == 404

        swimlanes = {}
        response.each do |board_ticket|
          swimlane = board_ticket['swimlane']
          next unless FlightPlanCli.settings.default_swimlane_ids.include? swimlane['id']

          swimlanes[swimlane['id']] ||= swimlane
          swimlanes[swimlane['id']]['tickets'] ||= []
          swimlanes[swimlane['id']]['tickets'] << board_ticket['ticket']
        end
        swimlanes
      end

      def print_swimlane(swimlane)
        puts "#{swimlane['name']} (#{swimlane['tickets'].count})"
          .colorize(Color::SWIMLANE)

        swimlane['tickets'].each do |ticket|
          print_ticket(ticket)
        end
        puts
      end

      def print_ticket(ticket)
        checked_out = git_current_branch =~ /##{ticket['remote_number']}[^0-9]/
        line =
          "  #{ticket['remote_number']}".colorize(Color::ISSUE_NO) +
          " #{ticket['remote_title']} ".colorize(Color::ISSUE)
        line = line.colorize(background: Color::CHECKED_OUT_BACKGROUND) if checked_out

        puts line
      end

      def git_current_branch
        @git_current_branch ||= git.current_branch
      end
    end
  end
end
