+++
title = "Account Creation"
slug = "account-creation"
weight = 20
draft = true
+++

Most interactions with BOMnipotent require some permission. The sole exception is accessing data classified as [TLP:WHITE](https://www.first.org/tlp/v1/) / [TLP:CLEAR](https://www.first.org/tlp/).

TODO: TLP2 is not supported yet

Permissions are linked to user accounts. For more information on how permissions are granted, see [User Management](/client/system-manager/user-management).

To create a new user account, run
```bash
bomnipotent_client --domain="<domain of BOMnipotent server>" user request <your email address>
```

TODO: Currently the public key file is also necessary.
TODO: Describe that a key pair is generated, and how you should treat the secret key.
