require 'spec_helper'

RSpec.describe FlightPlanCli::Api do
  subject { described_class.new(url: url, key: key, secret: secret) }
  let(:url) { 'https://flightplan.createk.io/api' }
  let(:key) { '55455565ghgjffgt' }
  let(:secret) { '334547865fhr2uyj' }

  let(:board_id) { 1 }

  describe '#issues' do


    it 'lists issue for a given board' do
      subject.board_tickets(board_id: board_id.to_s) 





    end
  end
end
