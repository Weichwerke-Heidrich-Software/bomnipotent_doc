+++
title = "Activating your Subscription"
slug = "subscription"
weight = 30
description = "Learn how to activate and manage your BOMnipotent subscription, including acquiring a subscription key and checking subscription status."
+++

Most actions that add data to your BOMnipotent database require an active subscription, while reading and removing data do not. This policy ensures that your users do not loose access to the existing data should you one day choose to stop paying for the product.

Commercial entities like companies can acquire a subscription on [bomnipotent.de](https://www.bomnipotent.de/pricing). If you are a non-commercial entity, you can use BOMnipotent without any charge. Request access by sending an email to [info@wwh-soft.com](mailto:info@wwh-soft.com).

Shortly after you have acquired a subscription, you will receive an email containing your subscription key.

Subscriptions can only be managed by a user with the "admin" role. [Create one](/server/setup/admin/) if you haven't already.

Logged in as that user, call

{{< example subscription_activate >}}

To check the current status of your subscription, run

{{< example subscription_status >}}
