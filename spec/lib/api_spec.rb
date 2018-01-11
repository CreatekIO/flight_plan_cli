require 'spec_helper'

RSpec.describe FlightPlanCli::Api do
  subject { described_class.new(url: url, key: key, secret: secret) }
  let(:url) { 'https://flightplan.createk.io/api' }
  let(:key) { '55455565ghgjffgt' }
  let(:secret) { '334547865fhr2uyj' }

  let(:board_id) { 1 }
  let(:board_tickets_url) { "#{url}/board_tickets.json" }
  let(:expected_headers) {
    {
      'Authorization' => 'Token token="55455565ghgjffgt:334547865fhr2uyj"'
    }
  }

  describe '#issues' do
    it 'lists issue for a given board' do
      stub = stub_request(:get, board_tickets_url)
             .with(
               query: hash_including(board_id: board_id.to_s),
               headers: expected_headers
             )
             .to_return(status: 200, body: '', headers: {})

      subject.board_tickets(board_id: board_id.to_s)

      expect(stub).to have_been_requested
    end
  end
end
