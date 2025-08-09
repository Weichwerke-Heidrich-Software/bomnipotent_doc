+++
title = "Creating an Admin"
slug = "admin"
weight = 20
description = "Learn how to create an admin in BOMnipotent, including user creation, temporary admin setup, and granting permanent admin rights."
+++

Several interactions with BOMnipotent require a user with admin rights. One of these is granting a new user admin rights. This means that some kind of bootstrapping mechanism is required.

## Step 1: Create User
First, you will need to [create a user account](/client/basics/account-creation/):

{{< example admin_user_request >}}

Once you have verified your email address, it will show up in the logs:

{{< example admin_email_verification >}}

To make things a litle less verbose, let's store the domain of your server and your email address in a [user session](/client/basics/user-session/):

{{< example admin_session_login >}}

To check that everything worked up until here, call:

{{< example health >}}

## Step 2: Mark User as TMP Admin

> Due to security reasons, the user needs to already exist in the database at this point. Otherwise, a malicious actor could anticipate the email address you use for your admin, and make their own request at an opportune time. To prevent this, the tmp admin mechanism blocks all requests to newly add this particular user to the database.

Next, you will become the user manager that was mentioned in the server reply: Log onto your server machine, and in your server configuration file append
```toml
[user]
tmp_admin = "admin@example.com"
```

Your server logs should now show that the configuration has been reloaded, in addition to the user request you made earlier.

## Step 3: Make User a full Admin

The server now treats authenticated requests from that user as if that user was an admin. To become a permanent admin, you first need to approve your user request. Back on the client, call

{{< example admin_user_approve >}}

Now you can make yourself a full server admin:

{{< example admin_user_role_add >}}

## Step 4: Remove TMP Admin Mark

The stat of being a temporary admin is intended to be, well, temporary. The server logs a warning whenever you use temporary access rights:

{{< example tmp_admin_warn >}}

But now that you have successfully made yourself a permanent admin, you can and should remove the "tmp_admin" field from the configuration file again.

You are now ready to [activate your subscription](/server/setup/subscription/).
