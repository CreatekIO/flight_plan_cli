require 'thor'
require 'colorize'
require 'git'
require 'flight_plan_cli/utils'
require 'flight_plan_cli/settings'
require 'flight_plan_cli/clients/git'
require 'flight_plan_cli/clients/flight_plan'
require 'flight_plan_cli/commands/list'
require 'flight_plan_cli/commands/checkout'
require 'flight_plan_cli/commands/release'
require 'flight_plan_cli/commands/config'
require 'flight_plan_cli/initializer'
require 'flight_plan_cli/version'
require 'flight_plan_cli/api'

module FlightPlanCli
  def self.settings
    @settings ||= Settings.new
  end
end
