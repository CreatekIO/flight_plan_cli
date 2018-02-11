module FlightPlanCli
  module Config
    private

    CONFIG_YAML_PATH = '.flight_plan_cli/config.yml'.freeze
    USER_YAML_PATH = '.flight_plan_cli/user.yml'.freeze

    attr_reader :board_id, :repo_id, :default_swimlane_ids
    attr_reader :api_url, :api_key, :api_secret
    attr_reader :git_ssh_public_key, :git_ssh_private_key

    def read_config
      @board_id = config['board_id']
      @repo_id = config['repo_id']
      @default_swimlane_ids = config['ls']['default_swimlane_ids']

      @api_url = config['api_url']
      @api_key = config['flight_plan_api_key']
      @api_secret = config['flight_plan_api_secret']
      @git_ssh_private_key = config['git_ssh_private_key'] || '~/.ssh/id_rsa'
      @git_ssh_public_key = config['git_ssh_public_key'] || '~/.ssh/id_rsa.pub'
    end

    def client
      @client ||= FlightPlanCli::Api.new(
        url: api_url,
        key: api_key,
        secret: api_secret,
        board_id: board_id,
        repo_id: repo_id
      )
    end

    def git
      @git ||= Rugged::Repository.new(Dir.pwd)
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
