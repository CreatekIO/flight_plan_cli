lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flight_plan_cli/version'

Gem::Specification.new do |spec|
  spec.name                  = 'flight_plan_cli'
  spec.version               = FlightPlanCli.version
  spec.authors               = ['John Cleary']
  spec.email                 = ['john@createk.io']
  spec.summary               = 'Command-line tool for FlightPlan'
  spec.homepage              = 'https://github.com/jcleary/flight_plan_cli'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  spec.files = Dir['{lib,bin}/**/**']
  spec.executables << 'flight_plan_cli'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15.4'
  spec.add_development_dependency 'rake', '~> 12.3.0'
  spec.add_development_dependency 'rspec', '~> 3.7.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3.0'
  spec.add_development_dependency 'version', '~> 1.1.1'

  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'rugged', '~> 0.26.0'
  spec.add_dependency 'thor', '~> 0.20.0'
end
