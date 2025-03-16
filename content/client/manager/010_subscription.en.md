+++
title = "Managing Subscriptions"
slug = "subscription"
weight = 10
+++

Most actions that add data to your BOMnipotent database require an active subscription, while reading and removing data do not. This policy ensures that your users do not loose access to the existing data should you one day choose to stop paying for the product.

Commercial entities like companies can acquire a subscription on [bomnipotent.de](https://www.bomnipotent.de/pricing). If you are a non-commercial entity, you can use BOMnipotent without any charge. Request access by sending an email to [info@wwh-soft.com](mailto:info@wwh-soft.com).

> This page describes how you can use BOMnipotent Client and your **subscription key** to (de)activate an instance of BOMnipotent Server. The subscription itself, meaning payment, validation and trialing are all handled by the external company Paddle. Describing the management of these aspects would be beyond the scope of this documentation. Please refer to [their help page](https://www.paddle.com/help) if you require assistance.

Shortly after you have acquired a subscription, you will receive an email containing your subscription key.

> Subscriptions can only be managed by a user with the "admin" role.

## Activating

To activate your new subscription, simply call:
```bash
bomnipotent_client subscription activate <YOUR-SUBSCRIPTION-KEY>
```
``` {wrap="false" title="output"}
[INFO] Successfully stored subscription key.
```

The server will tell you if something goes wrong during activation:
``` {wrap="false" title="output"}
[ERROR] Received response:
404 Not Found
Failed to activate subscription key: The subscription is missing in the sever database. Please visit https://www.wwh-soft.com to acquire it.
```

## Status

To get more information about your current subscription, call:

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

This output contains an obfuscated print of your key, a status, and some additional information.

## Removing

If you want to remove your subscription from an instance of BOMnipotent Server (because you for example want to use it for another instance), call
```bash
bomnipotent_client subscription remove <YOUR-SUBSCRIPTION-KEY>
```
``` {wrap="false" title="output"}
[INFO] Subscription key was removed
```

To avoid accidently deactivating a BOMnipotent Server instance that you have admin access to, this requires the correct key as an argument.

``` {wrap="false" title="output"}
[ERROR] Received response:
403 Forbidden
Subscription key does not match stored key
```
