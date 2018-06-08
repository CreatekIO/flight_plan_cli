module FlightPlanCli
  module Commands
    class Config
      def process
        # Load config up-front to trigger any errors
        FlightPlanCli.settings.config

        puts '= CONFIG ===='.bold
        puts "Using #{FlightPlanCli.settings.base_config_file}".green
        pretty_print FlightPlanCli.settings.base_config

        puts

        puts '= USER ===='.bold
        user_file = FlightPlanCli.settings.user_config_file

        if user_file
          puts "Using #{user_file}".green
          pretty_print FlightPlanCli.settings.user_config
        else
          puts 'No user config file found'.yellow
        end
      end

      private

      def pretty_print(config)
        puts YAML.dump(config).sub(/^---\n/, '')
      end
    end
  end
end
