require 'httparty'

module FlightPlanCli
  class Api
    include HTTParty
    def initialize(url:, key:, secret:)
      @url = url
      @key = key
      @secret = secret
    end

    def board_tickets(board_id: nil, repo_id: nil, repo_url: nil, assignee_username: nil)
      params = {}
      params[:board_id] = board_id unless board_id.nil?
      params[:repo_id] = repo_id unless repo_id.nil?
      params[:repo_url] = repo_url unless repo_url.nil?
      params[:assignee_username] = assignee_username unless assignee_username.nil?

      self.class.get("#{url}/board_tickets", query: params, headers: headers)
    end

    private

    attr_reader :url, :key, :secret

    def headers
    end
  end
end
