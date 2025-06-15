+++
title = "Managing Subscriptions"
slug = "subscription"
weight = 10
description = "Learn how to manage BOMnipotent subscriptions, including activation, status checks, and removal."
+++

Most actions that add data to your BOMnipotent database require an active subscription, while reading and removing data do not. This policy ensures that your users do not loose access to the existing data should you one day choose to stop paying for the product.

Commercial entities like companies can acquire a subscription on [bomnipotent.de](https://www.bomnipotent.de/pricing). If you are a non-commercial entity, you can use BOMnipotent without any charge. Request access by sending an email to [info@wwh-soft.com](mailto:info@wwh-soft.com).

> This page describes how you can use BOMnipotent Client and your **subscription key** to (de)activate an instance of BOMnipotent Server. The subscription itself, meaning payment, validation and trialing are all handled by the external company Paddle. Describing the management of these aspects would be beyond the scope of this documentation. Please refer to [their help page](https://www.paddle.com/help) if you require assistance.

Shortly after you have acquired a subscription, you will receive an email containing your subscription key.

> Subscriptions can only be managed by a user with the "admin" role.

## Activating

To activate your new subscription, simply call:
{{< example subscription_activate >}}

The server will tell you if something goes wrong during activation:
{{< example subscription_activate_wrong >}}

## Status

To get more information about your current subscription, call:
{{< example subscription_status >}}

This output contains an obfuscated print of your key, a status, and some additional information.

## Removing

If you want to remove your subscription from an instance of BOMnipotent Server (because you for example want to use it for another instance), call
{{< example subscription_remove >}}

To avoid accidently deactivating a BOMnipotent Server instance that you have admin access to, this requires the correct key as an argument.
{{< example subscription_remove_wrong >}}
