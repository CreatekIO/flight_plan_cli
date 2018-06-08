module FlightPlanCli
  module Utils
    def self.quit(message, error = nil)
      warn message.red.bold

      if error
        warn "\n  #{error.class}: #{error.message}".yellow
        warn(error.backtrace.map {|line| "    #{line}".white })
      end

      exit 1
    end
  end
end
