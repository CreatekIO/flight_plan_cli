module FlightPlanCli
  module Config
    private

    YAML_FILE = '.flight_plan_cli.yml'.freeze

    attr_reader :board_id, :repo_id, :default_swimlane_ids
    attr_reader :api_url, :api_key, :api_secret

    def read_config
      @board_id = config['board_id']
      @repo_id = config['repo_id']
      @default_swimlane_ids = config['ls']['default_swimlane_ids']

      @api_url = config['api_url']
      @api_key = ENV['FLIGHT_PLAN_API_KEY']
      @api_secret = ENV['FLIGHT_PLAN_API_SECRET']
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
          unless File.exist?(YAML_FILE)
            puts "Could not file #{YAML_FILE} file."
            exit 1
          end
          YAML.load_file(YAML_FILE)
        end
    end
  end
end
