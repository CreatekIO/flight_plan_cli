require 'spec_helper'

RSpec.describe FlightPlanCli::Commands::Checkout do
  describe '#process' do
    subject { described_class.new(issue_no) }
    let(:issue_no) { '1234' }
    let(:issue_json) { { 'issue_no' => issue_no } }
    let(:git) { double('git', branches: branches) }
    let(:branches) { double('branches', local: local_branches, remote: remote_branches) }
    let(:branch) { double('branch', name: branch_name) }
    let(:branch_name) { 'issue/#1234-title' }
    let(:remote) { double('remote', fetch: true) }
    let(:local_branches) { [] }
    let(:remote_branches) { [] }

    before do
      allow(subject).to receive(:read_config)
    end

    context 'when there is a local branch for the issue' do
      let(:local_branches) { [branch] }
      let(:output_text) { /Checking out local branch/ }

      it 'switches to the local branch' do
        stub_request(:get, 'http://dev.createk.io/api/board_tickets.json')
          .with(query: hash_including(remote_number: issue_no))
          .to_return(body: [issue_json].to_s)
        allow(subject).to receive(:git) { git }

        expect(git).to receive(:checkout).with(branch_name)
        expect { subject.process }.to output(output_text).to_stdout
      end
    end

    context 'when there is a remote branch for the issue' do
      let(:remote_branches) { [branch] }
      let(:output_text) { %r{Checking out and tracking remote branch 'issue\/#1234-title} }

      it 'checks out the remote branch locally' do
        stub_request(:get, 'http://dev.createk.io/api/board_tickets.json')
          .with(query: hash_including(remote_number: issue_no))
          .to_return(body: [issue_json].to_s)
        allow(subject).to receive(:git) { git }
        expect(git).to receive(:remote) { remote }

        expect(git).to receive(:checkout).with(branch_name)
        expect { subject.process }.to output(output_text).to_stdout
      end
    end
  end
end
