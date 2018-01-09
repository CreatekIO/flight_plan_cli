# FlightPlan Command Line Tool

[![](https://api.codeclimate.com/v1/badges/279bdb77cfa2bc375f5a/maintainability)](https://codeclimate.com/github/jcleary/flight_plan_cli/maintainability)
[![](https://api.codeclimate.com/v1/badges/279bdb77cfa2bc375f5a/test_coverage)](https://codeclimate.com/github/jcleary/flight_plan_cli/test_coverage)
[![CircleCI](https://circleci.com/gh/jcleary/flight_plan_cli.svg?style=svg)](https://circleci.com/gh/jcleary/flight_plan_cli)

FlightPlan is a issue tracking and release management tool. FlightPlan CLI is a tool which provides a convenient
way to manage issues, open PRs and deploy straight from the command line.

## Instillation
FlightPlan CLI (fp) is a Ruby gem, and as such can be installed using `gem` as follows:

```bash
gem install flight_plan_cli
```

## Setup
TBC

## Usage
Useful commands

```
fp ls           List open issues (issues in swimlanes with display_duration switched on)

fp co issue_no  Checkout the branch for the given issue number. Pull from remote/origin if
                it exists, otherwise create (from master) and set remote tracking branch 
 


