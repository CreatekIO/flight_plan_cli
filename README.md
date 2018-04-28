# FlightPlan Command Line Tool

FlightPlan is an integrated issue tracking and release management tool. FLightPlan CLI
privdes a convient way to manage issues, open PRs and deploy from the command line.

## Instillation
FlightPlan CLI (flight) is a Ruby gem, and as such can be installed using `gem` as follows:

```bash
gem install flight_plan_cli
```

## Setup
There are two configuration files for the project, both of which reside inside
`.flight_plan_cli/` in the root of your project.

### 1. user.yml
The file has your personal FlightPlan API key and should be git-ignored.
```yml
---
flight_plan_api_key=fgeryeeritudfg435345
flight_plan_api_secret=345fgfgj4i534t5345
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
flight ls           List open issues (issues in swimlanes with display_duration switched on)

flight ls mine      List open issues assigned to you.

flight co issue_no  Checkout the branch for the given issue number. Pull from remote/origin
                    if it exists, otherwise create (from master) and set remote tracking branch
```

## Roadmap
### PR info on `ls`
If a branch has an open PR, add info to the line in the `ls` output.
- **CI status:** (and other extensio status) amber o = processing, green ✓ = pass, red ✗ for
  failure, amber o for processing.
- **Code Reviews:** green "a" for approved, red "c" for changes

For example, if a PR had passed on CI and there was one approval and one request for
change, it would look like this
```
Code Review (1)
  3412 updating user can force a new ID [✓ac]
```

### Deployments
Ad-hoc deployments from the command line

```bash
# creates a new PR for issues in the Deploying column. If there is an open PR to master
# it will not create the PR.
flight release create

# merge the release PR (so long as there are no reported conflicts)
flight release merge

# close the PR without merging
flight release cancel
```

### PRs
Create a PR for an issue

```
# create a PR for an issue. If the issue_no is ommitted, the current branch is used.
flight pr [issue_no]
```

