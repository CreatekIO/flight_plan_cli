require 'spec_helper'

RSpec.describe FlightPlanCli::Api do
  subject { described_class.new(url: url, key: key, secret: secret, board_id: board_id) }
  let(:url) { 'https://flightplan.createk.io/api' }
  let(:key) { '55455565ghgjffgt' }
  let(:secret) { '334547865fhr2uyj' }

  let(:board_id) { 1 }
  let(:board_tickets_url) { "#{url}/boards/#{board_id}/board_tickets.json" }
  let(:expected_headers) {
    {
      'Authorization' => 'Token token="55455565ghgjffgt:334547865fhr2uyj"'
    }
  }

  describe '#issues' do
    it 'lists issue for a given board' do
      stub = stub_request(:get, board_tickets_url).with(
        headers: expected_headers,
        query: hash_including(
          assignee_username: '',
          remote_number: '',
          repo_id: ''
        )
      ).to_return(
        status: 200,
        body: '',
        headers: {}
      )

      subject.board_tickets

      expect(stub).to have_been_requested
    end
  end
end
