# FlightPlan Command Line Tool

FlightPlan is an integrated issue tracking and release management tool. FLightPlan CLI is
a tool which privdes a convient way to manage issues, open PR and deploy from the command
line.

## Instillation
FlightPlan CLI (fp) is a Ruby gem, and as such can be installed using `gem` as follows:

```bash
gem install flight_plan_cli
```

## Setup
There are two configuration files for the project, both of which reside inside the
`.flight_plan_cli/` folder

### 1. user.yml
The file has your personal settings such as the location of your SSH and FlightPLan keys
(this file should be git-ignored)
```yml
---
flight_plan_api_key=fgeryeeritudfg435345
flight_plan_api_secret=345fgfgj4i534t5345
git_ssh_private_key=~/.ssh/git_hub_key
git_ssh_public_key=~/.ssh/git_hub_key.pub
```

### 2. config.yml
This contains the general configuration for the project and should be committed to the
project.
```yml
---
api_url: 'http://dev.createk.io/api'
board_id: 4
repo_id: 6
ls:
  default_swimlane_ids:
    - 57 # Planning
    - 58 # Planning - Done
    - 59 # Development
    - 60 # Development - blocked
```
## Usage
Useful commands

```
fp ls           List open issues (issues in swimlanes with display_duration switched on)

fp ls mine      List open issues assigned to you.

fp co issue_no  Checkout the branch for the given issue number. Pull from remote/origin if
                it exists, otherwise create (from master) and set remote tracking branch



