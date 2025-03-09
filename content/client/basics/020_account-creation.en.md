+++
title = "Account Creation"
slug = "account-creation"
weight = 20
description = "Learn how to create a new user account in BOMnipotent, manage key pairs, and use stored keys for authentication with detailed command examples."
+++

Most interactions with BOMnipotent require some permission. The sole exception is accessing data classified as {{< tlp-white >}} / {{< tlp-clear >}}.

Permissions are linked to user accounts. For more information on how permissions are granted, see [User Management](/client/manager/user-management).

## Creating a new Account

To create a new user account, run
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

If you call this for the first time, it will create a new [key pair](https://en.wikipedia.org/wiki/Public-key_cryptography) using the [ED25519 Algorithm](https://en.wikipedia.org/wiki/EdDSA#Ed25519). A key pair consists of a public and a secret key. Both are stored in your local userfolder.

``` {wrap="false" title="output"}
[INFO] Generating new key pair
[INFO] Storing secret key to "/home/simon/.config/bomnipotent/secret_key.pem" and public key to "/home/simon/.config/bomnipotent/public_key.pem"
[INFO] User request submitted. It now needs to be confirmed by a user manager.
```

> The secret key is more commonly called "private key", but the author believes that "secret" is a more apt description and reduces the chance to confuse it with the public key.

The public key can, in principle, be shared with anyone. The "user request" call sends it to the BOMnipotent server. The secret key however should be treated like a password!

Subsequent calls to BOMnipotent Client will reuse an existing key pair.

Now that your request is made, you need to wait for a user manager of the server to approve it. After that you can start making [authenticated requests](/client/basics/authenticating/).

> If you are said user manager and are looking for how approve users, consult the section about [User Approval](/client/manager/user-management/user-approval/).

## Using stored Keys

If you have a key pair stored in the default user location (which depends on your platform), BOMnipotent Client will automatically read and use it.

If you would instead like to reuse an existing stored at a different location, you can add the path as a positional argument:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --domain=<server> user request <your-email> <path/to/key>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -d <server> user request <your-email> <path/to/key>
```
{{% /tab %}}
{{< /tabs >}}


> For this to work the key needs to have been generated using the [ED25519 Algorithm](https://en.wikipedia.org/wiki/EdDSA#Ed25519), and it needs to be stored in [PEM](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) format. If you insist on managing keys yourself, or would like to see an example, then the easiest way to generate such a pair is to call `openssl genpkey -algorithm ED25519 -out secret_key.pem` to generate a secret key, and then `openssl pkey -in secret_key.pem -pubout -out public_key.pem` to generate the corresponding public key.

If you accidently specify the path to your *secret* key, BOMnipotent Client will throw an error before sending it to the server.
