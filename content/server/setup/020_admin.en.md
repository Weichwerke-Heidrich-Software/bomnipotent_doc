+++
title = "Creating Admin"
slug = "admin"
weight = 20
draft = true
+++

Several interactions with BOMnipotent require a user with admin rights. One of these is granting a new user admin rights. This means that some kind of bootstrapping mechanism is required.

First, you will need to [create a user account](/client/basics/account-creation):
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --domain=<server> user request <your-email>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -d <server> user request <your-email>
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[INFO] Generating new key pair
[INFO] Storing secret key to "/home/simon/.config/bomnipotent/secret_key.pem" and public key to "/home/simon/.config/bomnipotent/public_key.pem"
[INFO] User request submitted. It now needs to be confirmed by a user manager.
```

Next, you will become said user manager: Log into your server.

TODO Needs tmp admin overhaul.
