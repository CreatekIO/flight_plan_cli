require 'spec_helper'

RSpec.describe FlightPlanCli::Api do
  subject { described_class.new(url: url, key: key, secret: secret) }
  let(:url) { 'https://flightplan.createk.io/api' }
  let(:key) { '55455565ghgjffgt' }
  let(:secret) { '334547865fhr2uyj' }

  let(:board_id) { 1 }

  describe '#issues' do
    it 'lists issue for a given board' do

      stub = stub_request(:get, "https://flightplan.createk.io/api/board_tickets").
        with(query: hash_including( { board_id: board_id.to_s })).
        to_return(status: 200, body: "", headers: {})
      
      subject.board_tickets(board_id: board_id.to_s) 

      expect(stub).to have_been_requested
    end
  end
end
