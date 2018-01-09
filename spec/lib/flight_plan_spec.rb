require 'spec_helper'

RSpec.describe FlightPlanCli do
  it 'has a version number' do
    expect(FlightPlanCli.version).not_to be nil
  end
end
