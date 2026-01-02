+++
title = "Configuring Tasks"
slug = "configuring-tasks"
weight = 10
+++

Beginning with version 1.4.0 of BOMnipotent Server, the parameters of periodic tasks can be configured in the [Config.toml](/server/configuration/config-file/) file. They are specified in the "[[tasks]]" sections:

```toml
# ... other content
[[tasks]]
name = "<name>"
period = "<period>"
enabled = true # Optional, true is the default.
# possibly more parameters

[[tasks]]
name = "<other name>"
```

> [!INFO]
> The double brackets around "tasks" mark this section as an entry in a list. This is why it may appear several times.

The only parameter that is always required is "name". It needs to contain the name of a task that BOMnipotent recognises. The names of all recognised tasks are listed in this documentation. This list may grow from version to version.

The "period" parameter controls how much time passes between two runs of this task.

> Strictly speaking, it specifies the minimal time between two runs, because all periodic tasks are run in the same thread and may thus delay each other.

The period may be specified in a human-readable format, for example "2 days" or "3h". If not provided, the period defaults to "1 day" and the task runs roughly every 24 hours.

> BOMnipotent does not stop you from choosing a ridiculously short period like "1 ms". However, tasks are designed with periods of hours in mind, not milliseconds. There is no guarantee that a task is run exactly when it is due. Any periods below one hour will likely just unnecessarily consume power and flood the logs.

Some periodic tasks are [enabled](/server/periodic-tasks/enabled/) by default, others are [not](/server/periodic-tasks/disabled/). Whether or not they are scheduled can be controlled with the "enabled" parameter. When specifying any parameters for a task, "enabled" defaults to true: Providing the "name" parameter alone is enough to enable a default-disabled task. On the other hand, only explicitly setting "enabled" to false will prevent a default-enabled task from running.

[Default-enabled](/server/periodic-tasks/enabled/) tasks come with default parameters. If you specify parameters in the Config.toml file, the default parameters are overridden.

After a server boot or reboot, all enabled periodic tasks are run as soon as the database is ready.

Periodic tasks support hot reloading of the configuration. Changing the Config.toml file while the server is running means that they are rescheduled according to the new parameters. If a previously disabled task is enabled, it is run directly after the configuration has been reloaded. The same is true when periods are shortened such that the next due time lies in the past.
