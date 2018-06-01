module FlightPlanCli
  class Settings
    CONFIG_YAML_PATH = '.flight_plan_cli/config.yml'.freeze
    USER_YAML_PATH = '.flight_plan_cli/user.yml'.freeze

    def board_id
      config['board_id']
    end

    def repo_id
      config['repo_id']
    end

    def default_swimlane_ids
      config['ls']['default_swimlane_ids']
    end

    def api_url
      config['api_url']
    end

    def api_key
      config['flight_plan_api_key']
    end

    def api_secret
      config['flight_plan_api_secret']
    end

    def config
      @config ||=
        begin
          check_config_exists
          YAML.load_file(CONFIG_YAML_PATH).merge(
            FileTest.exist?(USER_YAML_PATH) ? YAML.load_file(USER_YAML_PATH) : {}
          )
        end
    end

    def check_config_exists
      return if FileTest.exist?(CONFIG_YAML_PATH)
      puts "#{CONFIG_YAML_PATH} not found"
      exit 1
    end
  end
end
