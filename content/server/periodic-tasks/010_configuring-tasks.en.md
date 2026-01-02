+++
title = "Configuring Tasks"
slug = "configuring-tasks"
weight = 10
+++

Beginning with version 1.4.0 or BOMnipotent Server, the parameters of periodic tasks can be configured in the [Config.toml](/server/configuration/config-file/) file. The configuration is done via a list of parameters under the "[[tasks]]" section.

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

> [!NOTE] Note
> The double brackets around "tasks" mark this as a list in TOML syntax.

The only required parameter is "name". It needs to refer to the name of a task that BOMnipotent recognises. The names of all recognised tasks are listed in this documentation. It may grow from version to version.

The "period" parameter may be specified in a human-readable format, for example "2 days" or "3h". If not provided, the period defaults to "1 day".

> BOMnipotent does not stop you from choosing a ridiculously short period like "1 ms". However, tasks are designed with periods of hours in mind, not milliseconds. There is no guarantee that a task is run exactly when it is due. Any periods below one hour will likely just unnecessarily consume power and flood the logs.

Some tasks are [enabled](/server/periodic-tasks/enabled/) by default, others are [not](/server/periodic-tasks/disabled/). Whether or not they are scheduled can be controlled with the "enabled" parameter. When specifying parameters for a task, "enabled" defaults to true: Providing the "name" parameter alone is enough to enable a default-disabled task. On the other hand, only explicitly setting "enabled" to false will prevent a default-enabled task from running.

[Default-enabled](/server/periodic-tasks/enabled/) tasks come with default parameters. If you specify parameters in the Config.toml file, the default parameters are overridden.
