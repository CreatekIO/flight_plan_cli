module FlightPlanCli
  module Clients
    module Git
      def git
        @git ||= ::Git.open(Dir.pwd)
      end
    end
  end
end
