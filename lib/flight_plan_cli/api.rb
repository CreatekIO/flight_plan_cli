require 'httparty'

module FlightPlanCli
  class Api
    def initialize(url:, key:, secret:, board_id: nil, repo_id: nil)
      @url = url
      @key = key
      @secret = secret
      @board_id = board_id
      @repo_id = repo_id
    end

    def board_tickets(assignee_username: nil, remote_number: nil)
      params = {
        board_id: board_id,
        repo_id: repo_id,
        assignee_username: assignee_username,
        remote_number: remote_number
      }

      HTTParty.get("#{url}/board_tickets.json", query: params, headers: headers)
    end

    private

    attr_reader :url, :key, :secret
    attr_reader :board_id, :repo_id

    def headers
      @headers = {
        'Authorization' => "Token token=\"#{key}:#{secret}\""
      }
    end
  end
end
