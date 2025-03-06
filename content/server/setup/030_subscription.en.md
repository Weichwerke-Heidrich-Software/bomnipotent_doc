+++
title = "Activating your Subscription"
slug = "subscription"
weight = 30
draft = true
+++

Most actions that add data to your BOMnipotent database require an active subscription, while reading and removing data do not. This policy ensures that your users do not loose access to the existing data should you one day choose to stop paying for the product.

Commercial entities like companies can acquire a subscription on [bomnipotent.de](https://www.bomnipotent.de/pricing). If you are a non-commercial entity, you can use BOMnipotent without any charge. You can request access by sending an email to [info@wwh-soft.com](mailto:info@wwh-soft.com).

Shortly after you have acquired a subscription, you will receive an email containing your subscription key.

Subscriptions can only be managed by a user with the "admin" role. [Create one](/server/setup/admin/) if you haven't already.

Logged in as that user, call
```bash
bomnipotent_client subscription activate <your-subscription-key>
```
``` {wrap="false" title="output"}
[INFO] Successfully stored subscription key.
```

To check the current status of your subscription, run
```bash
bomnipotent_client subscription status
```
``` {wrap="false" title="output"}
╭──────────┬───────────────────────────┬─────────────────────┬─────────────────────────┬─────────────────────────┬───────────────────────────╮
│ Key      │ Product                   │ Subscription Status │ Valid Until             │ Last Updated            │ Assessment                │
├──────────┼───────────────────────────┼─────────────────────┼─────────────────────────┼─────────────────────────┼───────────────────────────┤
│ ***qcgy2 │ pro_01jg3k3ndmpmyx9z7he86 │ active              │ 2026-03-01 04:19:13 UTC │ 2025-03-01 04:19:13 UTC │ The Subscription is valid │
│          │ z5430                     │                     │                         │                         │                           │
╰──────────┴───────────────────────────┴─────────────────────┴─────────────────────────┴─────────────────────────┴───────────────────────────╯
```
