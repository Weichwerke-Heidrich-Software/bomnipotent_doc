+++
title = "User Expiration"
slug = "user-expiration-period"
weight = 40
description = "Learn how to configure the user expiration period in BOMnipotent."
+++

When a request for a new [user account](/client/basics/account-creation/) is made, it deposits a public key in the database.

This key has an expiration data, after which it is not accepted anymore. This can be seen by calling:
```
./bomnipotent_client user list
```
``` {wrap="false" title="output"}
╭───────────────────┬──────────┬───────────────────────────┬───────────────────────────╮
│ User Email        │ Status   │ Expires                   │ Last Updated              │
├───────────────────┼──────────┼───────────────────────────┼───────────────────────────┤
│ info@wwh-soft.com │ APPROVED │ 2026-03-03 11:30:15.62432 │ 2025-03-02 11:47:38.51048 │
│                   │          │ 5 UTC                     │ 5 UTC                     │
╰───────────────────┴──────────┴───────────────────────────┴───────────────────────────╯
```

By default, the key is valid for a little over a year after it was requested. This time can be configured with the "expiration_period" parameter, which is located under "[user]". As values it accepts a time period in the human readable format "<number> <unit>", where "<unit>" can be any of "year", "month", "week", "day", or their plural variants.
{{< tabs >}}
{{% tab title="default time" %}}
```toml
[user]
expiration_period = "366 days"
```
{{% /tab %}}
{{% tab title="several years" %}}
```toml
[user]
expiration_period = "5 years"
```
{{% /tab %}}
{{% tab title="one month" %}}
```toml
[user]
expiration_period = "1 month"
```
{{% /tab %}}
{{% tab title="three weeks" %}}
```toml
[user]
expiration_period = "3 weeks"
```
{{% /tab %}}
{{% tab title="five days" %}}
```toml
[user]
expiration_period = "5 days"
```
{{% /tab %}}
{{< /tabs >}}

> If you really hate your users you could also use "hours", "minutes", seconds", "ms", "us" or "ns" as units. BOMnipotent does not question how realistic your expectations are.

Changing this configuration **does not** affect the expiration dates of existing users! It will only influence how much time is given to newly requested users.
