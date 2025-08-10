+++
title = "Account Creation"
slug = "account-creation"
weight = 20
description = "Learn how to create a new user account in BOMnipotent, manage key pairs, and use stored keys for authentication with detailed command examples."
+++

Most interactions with BOMnipotent require some permission. The sole exception is accessing data classified as {{<tlp-white>}} / {{<tlp-clear>}}.

Permissions are linked to user accounts. For more information on how permissions are granted, see the section about [Access Management](/client/manager/access-management/).

## Creating a new Account

To create a new user account, run

{{< example "user_request" >}}

If you call this for the first time, it will create a new [key pair](https://en.wikipedia.org/wiki/Public-key_cryptography) following the [OpenPGP](/integration/open-pgp/) standard. A key pair consists of a public and a secret key. Both are stored in your local userfolder.

> The secret key is more commonly called "private key", but the author believes that "secret" is a more apt description and reduces the chance to confuse it with the public key.

The public key can, in principle, be shared with anyone. The "user request" call sends it to the BOMnipotent server. The secret key however should be treated like a password!

Subsequent calls to BOMnipotent Client will reuse an existing key pair.

Most BOMnipotent Server instances will require you to confirm that you have access to the provided email address. They will send you a verification link, which expires after some time.

If you missed the time window or something else went wrong, simply send the same request to the server again. It will then generate a new verification email for you:

{{< example "user_request_resend" >}}

After your request is made and your email verified, you need to wait for a user manager of the server to approve your account. Once that happened you can start making [authenticated requests](/client/basics/authenticating/).

> If you are said user manager and are looking for how approve users, consult the section about [User Management](/client/manager/access-management/user-management/).

## Requesting a Robot Account

Not all accounts are necessarily associated with human users. BOMnipotent is built with pipeline integration in mind. To create an account to be used in a automation, add the '--robot' option to the request:

{{< example "user_request_robot" >}}

This request will mark the account as a robot, and not send a verification mail.

## Using stored Keys

If you have a key pair stored in the default user location (which depends on your platform), BOMnipotent Client will automatically read and use it.

If you would instead like to reuse an existing key stored at a different location, you can add the path as a positional argument:

{{< example "user_request_stored_key" >}}

> For this to work the key needs to follow the [OpenPGP](/integration/open-pgp/) standard, and it needs to be stored in [PEM](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) format.

If you accidently specify the path to your *secret* key, BOMnipotent Client will throw an error before sending it to the server.
