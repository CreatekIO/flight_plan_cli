# FlightPlan Command Line Tool

FlightPlan is an integrated issue tracking and release management tool. FLightPlan CLI is a tool which privdes a convient
way to manage issues, open PR and deploy from the command line.

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
fp ls                 List open issues (issues in swimlanes with display_duration switched on)

fp ls mine            List open issues assigned to you.

fp checkout issue_no  Checkout the branch for the given issue number. Pull from remote/origin if
                      it exists, otherwise create (from master) and set remote tracking branch 

fp deploy             Create a deployment for the issues in the deploy swimlane


``` 
 


