+++
title = "User Management"
slug = "user-management"
weight = 30
description = "Learn how to manage users in BOMnipotent, including creating, listing, approving, denying, and deleting user accounts."
+++

The first step when creating a new user is to request a new account. This step is described [elsewhere](/client/basics/account-creation/), because it is relevant for managers and consumers alike.

From BOMnipotent's point of view, a user is associated with a unique email address, which is used as an identifier, and a public key, which is used for authentication. This is all the data sent during the creation of a new user account.

After a new account has been requested, it is up to a user manager to approve or deny the request.

> For most user interactions, including listing, you need the {{<user-management-en>}} permission.

## Listing

To list all users in your database, call
```
bomnipotent_client user list
```

``` {wrap="false" title="output"}
╭────────────────────┬───────────┬─────────────────────────┬─────────────────────────╮
│ User Email         │ Status    │ Expires                 │ Last Updated            │
├────────────────────┼───────────┼─────────────────────────┼─────────────────────────┤
│ admin@wwh-soft.com │ APPROVED  │ 2026-03-23 04:51:26 UTC │ 2025-03-22 04:51:26 UTC │
│ info@wildeheide.de │ REQUESTED │ 2026-03-23 03:52:21 UTC │ 2025-03-22 03:52:21 UTC │
╰────────────────────┴───────────┴─────────────────────────┴─────────────────────────╯
```

You can see the email addresses of the users and their stati. 

> A user that does not have the status APPROVED has no special permissions, no matter which roles they have.

An expiration date is also associated with each user, which is the point in time at which the public key is considered invalid and has to be renewed. The period for which a key is considered valid can [be freely configured](/server/configuration/optional/user-expiration-period/) in the server config.

## Approval or Denial

If you were expecting the user request, you can approve it via
```
bomnipotent_client user approve <EMAIL>
```

``` {wrap="false" title="output"}
[INFO] Changed status of info@wildeheide.de to APPROVED
```

Analogously, you can decide agains allowing this user any special access:
```
bomnipotent_client user deny <EMAIL>
```

``` {wrap="false" title="output"}
[INFO] Changed status of info@wildeheide.de to DENIED
```

> It is possible to deny a user that has already been approved, effectively revoking the account.

## Removing

If you want to get rid of a user account alltogether, call
```
bomnipotent_client user remove <EMAIL>
```

``` {wrap="false" title="output"}
[INFO] Deleted user info@wildeheide.de
```

This also removes all roles associated with the user.
