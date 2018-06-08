require 'spec_helper'

RSpec.describe FlightPlanCli::Commands::Release do
  describe '#process' do
    let(:output_text) {
      ("Created #{repo_name} release \"#{release_name}\" with the following tickets:".green + "\n") +
      ("  ##{remote_number} - #{remote_title}".green + "\n")
    }
    let(:release_name) { 'FlightPlan CLI 2018-07-01' }
    let(:repo_name) { 'FlightPlan CLI' }
    let(:repo_id) { 24 }
    let(:flight_plan) { double('FlightPlan') }
    let(:remote_number) { 1255 }
    let(:remote_title) { 'A tricky bug' }
    let(:release) {
      {
        'id' => 111,
        'title' => release_name,
        'repo_releases' => [
          {
            'repo' => {
              'id' => repo_id,
              'name' => repo_name,
            },
            'board_tickets' => [
              'id' => 5,
              'ticket' => {
                'remote_number' => remote_number,
                'remote_title' => remote_title
              }
            ]
          }
        ]
      }
    }
    let(:response) { { 'release' => release } }
    it 'calls the release API' do
      expect(subject).to receive(:flight_plan) { flight_plan }
      expect(flight_plan).to receive(:create_release)
        .and_return(response)
      expect(response).to receive(:code).and_return(201)

      expect { subject.process }.to output(output_text).to_stdout
    end
  end
end

