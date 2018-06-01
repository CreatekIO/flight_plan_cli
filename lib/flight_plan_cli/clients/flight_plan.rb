module FlightPlanCli
  module Clients
    module FlightPlan
      def flight_plan
        @flight_plan ||= FlightPlanCli::Api.new(
          url: FlightPlanCli.settings.api_url,
          key: FlightPlanCli.settings.api_key,
          secret: FlightPlanCli.settings.api_secret,
          board_id: FlightPlanCli.settings.board_id,
          repo_id: FlightPlanCli.settings.repo_id
        )
      end
    end
  end
end
