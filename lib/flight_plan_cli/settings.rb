module FlightPlanCli
  module Settings
    CONFIG_YAML_PATH = '.flight_plan_cli/config.yml'.freeze
    USER_YAML_PATH = '.flight_plan_cli/user.yml'.freeze

    def self.board_id
      config['board_id']
    end

    def self.repo_id
      config['repo_id']
    end

    def self.default_swimlane_ids
      config['ls']['default_swimlane_ids']
    end

    def self.api_url
      config['api_url']
    end

    def self.api_key
      config['flight_plan_api_key']
    end

    def self.api_secret
      config['flight_plan_api_secret']
    end

    def self.config
      @config ||=
        begin
          check_config_exists
          YAML.load_file(CONFIG_YAML_PATH).merge(
            FileTest.exist?(USER_YAML_PATH) ? YAML.load_file(USER_YAML_PATH) : {}
          )
        end
    end

    def self.check_config_exists
      return if FileTest.exist?(CONFIG_YAML_PATH)
      puts "#{CONFIG_YAML_PATH} not found"
      exit 1
    end
  end
end
