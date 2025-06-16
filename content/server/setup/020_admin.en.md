+++
title = "Creating an Admin"
slug = "admin"
weight = 20
description = "Learn how to create an admin in BOMnipotent, including user creation, temporary admin setup, and granting permanent admin rights."
+++

Several interactions with BOMnipotent require a user with admin rights. One of these is granting a new user admin rights. This means that some kind of bootstrapping mechanism is required.

## Step 1: Create User
First, you will need to [create a user account](/client/basics/account-creation):

{{< example admin_user_request >}}

To make things a litle less verbose, let's store the domain of your server and your email address in a [user session](/client/basics/user-session/):

{{< example admin_session_login >}}

## Step 2: Mark User as TMP Admin

> Due to security reasons, the user needs to already exist in the database at this point. Otherwise, a malicious actor could anticipate the email address you use for your admin, and make their own request at an opportune time. To prevent this, the tmp admin mechanism blocks all requests to newly add this particular user to the database.

Next, you will become the user manager that was mentioned in the server reply: Log onto your server machine, and in your server configuration file prepend
```toml
tmp_admin = "<your-email>"
```

> It is important to add this line **at the beginning** of the file, otherwise BOMnipotent might try to interpret this field as part of another section.

Your server logs should now show that the configuration has been reloaded, in addition to the user request you made earlier.

```
docker logs bomnipotent_server
```
``` {wrap="false" title="output"}
...
2025-03-06 11:30:15 +00:00 [INFO] Received POST request from 101.102.103.104 to https://bomnipotent.wwh-soft.com/user/info@wwh-soft.com
2025-03-06 11:32:56 +00:00 [INFO] Configuration successfully reloaded from "/etc/bomnipotent_server/configs/config.toml"
...
```

## Step 3: Make User a full Admin

The server now treats authenticated requests from that user as if that user was an admin. To become a permanent admin, you first need to approve your user request. Back on the client, call

{{< example admin_user_approve >}}

Now you can make yourself a full server admin:

{{< example admin_user_role_add >}}

## Step 4: Remove TMP Admin Mark

The stat of being a temporary admin is intended to be, well, temporary. The server logs a warning whenever you use temporary access rights:
```
docker logs bomnipotent_server -n 4
```
``` {wrap="false" title="output"}
2025-03-06 14:51:35 +00:00 [INFO] Received POST request from info@wwh-soft.com to https://bomnipotent.wwh-soft.com/user/info@wwh-soft.com/roles
2025-03-06 14:51:35 +00:00 [WARN] Temporary admin functionality is enabled for info@wwh-soft.com
2025-03-06 14:51:35 +00:00 [INFO] User info@wwh-soft.com was authenticated as a temporary admin
2025-03-06 14:51:35 +00:00 [INFO] Temporary admin info@wwh-soft.com has permission USER_MANAGEMENT to perform this action
```

But now that you have successfully made yourself a permanent admin, you can and should remove the "tmp_admin" field from the configuration file again.

You are now ready to [activate your subscription](/server/setup/subscription/).
