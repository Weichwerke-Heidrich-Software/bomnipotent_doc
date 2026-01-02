+++
title = "Check for Updates"
slug = "check-for-updates"
weight = 10
+++

This task queries [www.bomnipotent.de](https://www.bomnipotent.de/downloads) to check if a new version of BOMnipotent Server is available. It prints a log with INFO level if the server can be updated, and a log with WARN level if your version is no longer supported.

The name of this task is "check_for_updates", and it accepts the following [configurations](/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "check_for_updates"
period = "1 day" # Optional
enabled = true # Optional
```
