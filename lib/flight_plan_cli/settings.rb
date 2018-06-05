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
      @config ||= base_config.merge(user_config)
    end

    def base_config_file
      @base_config_file ||=
        begin
          locate_file(CONFIG_YAML_PATH) or Utils.quit("#{CONFIG_YAML_PATH} not found")
        end
    end

    def base_config
      @base_config ||= load_yaml(base_config_file)
    end

    def user_config_file
      @user_config_file ||= locate_file(USER_YAML_PATH)
    end

    def user_config
      @user_config ||= load_yaml(user_config_file)
    end

    private

    def locate_file(filename)
      Pathname.pwd.ascend do |path|
        found_file = path.join(filename)

        return found_file if found_file.readable? && !found_file.directory?
        break if path == home_directory
      end
    end

    def load_yaml(filename)
      if filename
        YAML.load_file(filename)
      else
        {}
      end
    rescue YAML::Exception => error
      Utils.quit "Error parsing `#{filename}`:", error
    rescue => error
      Utils.quit "Error loading `#{filename}`:", error
    end

    def home_directory
      @home_directory ||= Pathname.new(Dir.home)
    end
  end
end
