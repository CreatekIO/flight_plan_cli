# FlightPlan Command Line Tool

FlightPlan is an integrated issue tracking and release management tool. FLightPlan CLI is a tool which privdes a convient
way to manage issues, open PR and deploy from the command line.

## Instillation
FlightPlan CLI (fp) is a Ruby gem, and as such can be installed using `gem` as follows:

```bash
gem install flight_plan_cli
```

## Setup
You may wish to creat a `.env` file in your project folder for overriding default
flight_plan_cli configuration. Here is an example:
```yaml
FLIGHT_PLAN_API_KEY=fgeryeeritudfg435345
FLIGHT_PLAN_API_SECRET=345fgfgj4i534t5345
GIT_SSH_PRIVATE_KEY=~/.ssh/git_hub_key
GIT_SSH_PUBLIC_KEY=~/.ssh/git_hub_key.pub
```

## Usage
Useful commands

```
fp ls           List open issues (issues in swimlanes with display_duration switched on)

fp ls mine      List open issues assigned to you.

fp co issue_no  Checkout the branch for the given issue number. Pull from remote/origin if
                it exists, otherwise create (from master) and set remote tracking branch



