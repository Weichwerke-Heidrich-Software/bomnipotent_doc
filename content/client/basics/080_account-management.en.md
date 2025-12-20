+++
title = "Account Management"
description = "Guide to revoking compromised user keys: use 'user revoke key', mark keys REVOKED, prevent requests, find session data and delete local key."
slug = "account-management"
weight = 80
+++

## Revoking Keys

In an ideal world, the key associated with a user account is used until it expires. However, by some mishap, the secret key might get compromised. It then needs to be revoked.

To revoke a key, call the "user revoke key" command:

{{< example "user_revoke_key" "1.3.0" >}}

This sets the status of the key currently to "REVOKED". It can no longer be used.

{{< example "whoami_revoked_key" "1.3.0" >}}

The revoked key is kept in the database. This makes sure that it can not be used in a subsequent user request:

{{< example "user_request_revoked_key" "1.3.0" >}}

Afer having revoked a key, you should delete it from your file system. You can find its location in the session data:

{{< example "session_status_revoked_key" >}}
