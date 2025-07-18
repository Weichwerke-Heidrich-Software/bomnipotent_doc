+++
title = "Temporary Admin"
slug = "tmp-admin"
weight = 20
description = "Learn how to enable temporary admin permissions in your server configuration using the tmp_admin parameter for secure initial admin setup."
+++

Only an admin can give admin permissions to a user. In order to create the first admin, you therefore need to enable these permissions via another, temporary path. This is done with the config parameter "tmp_admin", which takes the email address of a user as an input:

```toml
[user]
tmp_admin = "<email>"
```

The whole procedure is described in the [setup instructions](/server/setup/admin/).

For security reasons, the rules surrounding temporary adminship are rather strict, and allow only one specific order of operations:
1. Request a new user. The "tmp_admin" parameter may not be set at this point, or the request is denied by the server. A request for a new user with the same email is also denied.
1. Mark that user as a temporary admin in the configuration. If the user does not exists, the configuration will fail to load.
1. Make the user a proper admin by approving them and adding the admin role.
1. Remove the "tmp_admin" parameter from the server configuration. The server logs will print warning messages while it is still active.

> If the rules were less strict and you could designate a temporary admin before the user is registered in the database, an attacker could potentially request a new user with the correct email address and would then have admin permissions on your system.
