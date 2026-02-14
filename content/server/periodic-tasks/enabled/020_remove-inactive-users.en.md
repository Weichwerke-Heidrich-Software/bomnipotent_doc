+++
title = "Remove inactive Users"
slug = "remove-inactive-users"
weight = 20
description = "Periodic task to remove inactive users after 30+ days, automating user-data cleanup and GDPR-compliant retention policies."
+++

This tasks checks the user database for entries that have been expired for more than 30 days, and removes them.

This ensures that you do not store personally identifiable data like email addresses longer than is required. This is a central credo of the European Union's [General Data Protection Regulation](https://gdpr-info.eu/) (GDPR).

> [!NOTE] Stay compliant
> If you provide your services in the European Union, you need to comply with the GDPR. Do not turn off this periodic task without a backup process for cleaning your database.

The name of this task is "remove_inactive_users". It accepts the following [configurations](/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "remove_inactive_users"
period = "1 day" # Optional
enabled = true # Optional
```

The time until expired users are removed can be configured under the ["[user]"](/server/configuration/optional/user-expiration-period/#removal-period) section.
