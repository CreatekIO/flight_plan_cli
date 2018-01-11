require 'httparty'

module FlightPlanCli
  class Api
    def initialize(url:, key:, secret:)
      @url = url
      @key = key
      @secret = secret
    end

    def board_tickets(
      board_id: nil, repo_id: nil, repo_url: nil, assignee_username: nil
    )
      params = {
        board_id: board_id,
        repo_id: repo_id,
        repo_url: repo_url,
        assignee_username: assignee_username
      }

      HTTParty.get("#{url}/board_tickets.json", query: params, headers:
                    headers)
    end

    private

    attr_reader :url, :key, :secret

    def headers
      @headers = {
        'Authorization' => "Token token=\"#{key}:#{secret}\""
      }
    end
  end
end
