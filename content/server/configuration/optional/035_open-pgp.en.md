+++
title = "OpenPGP Config"
slug = "open-pgp"
description = "Learn how to configure OpenPGP keys in BOMnipotent Server to enable document signing and become a CSAF Trusted Provider."
weight = 35
+++

This section describes how you can make your OpenPGP key pair available to your instance of BOMnipotent Server. This allows it to host your public key and sign your documents, which is necessary in order to become a [CSAF Trusted Provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#723-role-csaf-trusted-provider).

> To learn more about OpenPGP in general, and how to create a key pair for your project, read the [article](/integration/open-pgp/) dedicated to that topic.

## OpenPGP Configuration

The "openpgp" section in your config.toml accepts the following fields:
```toml
[open_pgp]
public_key_path = "public_key.asc"
secret_key_path = "secret_key.asc"
passphrase = "${PGP_PASSPHRASE}" # Optional
```

The configurations "public_key_path" and "secret_key_path" need to point to files containing an ASCII-armoured public or secret OpenGPG key, respectively. If you followed the [tutorial](/integration/open-pgp/) to generate and export your keys, the server will accept them.

> Don't worry: If you accidently mix the keys up, BOMnipotent will refuse to load your configuration instead of leaking your secret key.

> [!TIP]
> If you put your keys adjacent to your config.toml, you benefit from BOMnipotent's hot reloading, meaning your server is automatically updated whenever you change your key files.

It is recommended to protect your secret key with a passphrase. To allow BOMnipotent Server to use it, you can provide it via the "passphrase" configuration.

> [!NOTE]
> You should **not** store your passphrase directly in the config, but instead pass it on via an environment variable. In the example above, "PGP_PASSPHRASE" is used as the (arbitrary) name of the variable.

## Benefits

Before accepting the configuration, BOMnipotent Server will check it for consistency. It loads the keys, and signs and verifies a test message, to ensure that everything is in order.

The server then offers your public key over the paths "\<your-domain\>/openpgp-key.asc" (the intuitive path) and "\<your-domain\>/.well-known/csaf/openpgp/openpgp-key.asc" (the path suggested by the [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#7120-requirement-20-public-openpgp-key)).

Finally, the server declares you a "CSAF trusted provider" in your [provider metadata](/server/configuration/required/provider-metadata/).
