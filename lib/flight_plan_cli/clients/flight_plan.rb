module FlightPlanCli
  module Clients
    module FlightPlan
      def flight_plan
        @flight_plan ||= FlightPlanCli::Api.new(
          url: FlightPlanCli::Settings.api_url,
          key: FlightPlanCli::Settings.api_key,
          secret: FlightPlanCli::Settings.api_secret,
          board_id: FlightPlanCli::Settings.board_id,
          repo_id: FlightPlanCli::Settings.repo_id
        )
      end
    end
  end
end
