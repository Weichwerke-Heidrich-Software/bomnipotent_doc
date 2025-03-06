+++
title = "Creating an Admin"
slug = "admin"
weight = 20
+++

Several interactions with BOMnipotent require a user with admin rights. One of these is granting a new user admin rights. This means that some kind of bootstrapping mechanism is required.

## Step 1: Create User
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

To make things a litle less verbose, let's store the domain of your server and your email address in a [user session](/client/basics/user-session/):
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --domain=<server> --email=<your-email> session login
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -d <server> -e <your-email> session login
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[INFO] Storing session data in /home/simon/.config/bomnipotent/session.toml
```

## Step 2: Mark User as TMP Admin

> Due to security reasons, the user needs to already exist in the database at this point. Otherwise, a malicious actor could anticipate the email address you use for your admin, and make their own request at an opportune time. To prevent this, the tmp admin mechanism blocks all requests to newly add this particular user to the database.

Next, you will become the user manager mentioned in the server reply: Log onto your server machine, and in your server configuration file prepend
```toml
tmp_admin = "<your-email>"
```

> It is important to add this line **at the beginning** of the file, otherwise BOMnipotent might try to interpret this field as part of the "[publisher_metadata]" object.

Your server logs should now show that the configuration has been reloaded, in addition to the user request you made earlier.

```bash
docker logs bomnipotent_server
```
``` {wrap="false" title="output"}
...
2025-03-02 11:30:15 +00:00 [INFO] Received POST request from 101.102.103.104 to https://bomnipotent.wwh-soft.com/user/info@wwh-soft.com
2025-03-02 11:32:56 +00:00 [INFO] Configuration successfully reloaded from "/etc/bomnipotent_server/configs/config.toml"
...
```

## Step 3: Make User a full Admin

The server now treats authenticated requests from that user as if that user was an admin. To become a permanent admin, you first need to approve your user request. Back on the client, call

```bash
bomnipotent_client user approve <your-email>
```
``` {wrap="false" title="output"}
[INFO] Changed status of info@wwh-soft.com to APPROVED
```

Now you can make yourself a full server admin:
```bash
bomnipotent_client user-role add <your-email> admin
```
``` {wrap="false" title="output"}
[INFO] Added role to user
```

## Step 4: Remove TMP Admin Mark

The stat of being a temporary admin is intended to be, well, temporary. The server logs a warning whenever you use temporary access rights:
```bash
docker logs bomnipotent_server -n 4
```
``` {wrap="false" title="output"}
2025-03-06 14:51:35 +00:00 [INFO] Received POST request from info@wwh-soft.com to https://bomnipotent.wwh-soft.com/user/info@wwh-soft.com/roles
2025-03-06 14:51:35 +00:00 [WARN] Temporary admin functionality is enabled for info@wwh-soft.com
2025-03-06 14:51:35 +00:00 [INFO] User info@wwh-soft.com was authenticated as a temporary admin
2025-03-06 14:51:35 +00:00 [INFO] Temporary admin info@wwh-soft.com has permission USER_MANAGEMENT to perform this action
```

But now that you have successfully made yourself a permanent admin, you can and should remove the "tmp_admin" field from the configuration file again.

You are now read to [activate your subscription](/server/setup/subscription/).
