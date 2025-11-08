+++
title = "User Management"
slug = "user-management"
weight = 30
description = "Learn how to manage users in BOMnipotent, including creating, listing, approving, denying, and deleting user accounts."
+++

The first step when creating a new user is to request a new account. This step is described [elsewhere](/client/basics/account-creation/), because it is relevant for managers and consumers alike.

From BOMnipotent's point of view, a user is associated with a unique email address or username, which is used as an identifier, and a public key, which is used for authentication. This is all the data sent during the creation of a new user account.

After a new account has been requested, it is up to a user manager to approve or deny the request.

> For most user interactions, including listing, you need the {{<user-management-en>}} permission.

## List

To list all users in your database, call

{{< example user_list >}}

You can see the email addresses or usernames of the users and their stati. 

> A user that does not have the status APPROVED has no special permissions, no matter which roles they have.

An expiration date is also associated with each user, which is the point in time at which the public key is considered invalid and has to be renewed. The period for which a key is considered valid can [be freely configured](/server/configuration/optional/user-expiration-period/) in the server config.

The list of users can be filtered by username, approval status, and whether or not they are expired:

{{< example user_filtered_list >}}

The "true" argument for the expired filter is optional:

{{< example user_list_expired >}}

## Approve or Deny

If you were expecting the user request, you can approve it via

{{< example user_approve >}}

If the user has not yet verified their email address, the server denies the approval. If you are absolutely sure that you know what you are doing, you can overwrite this behaviour with the 'allow-unverified' option (there's no short version for options that bypass security measures):

{{< example user_approve_unverified >}}

Analogously, you can decide against allowing this user any special access:

{{< example user_deny >}}

Contrary to approval, this action does not care which status the user had before the denial.

> It is possible to deny a user that has already been approved, effectively revoking the account.

A user whose previous request for an account was denied cannot request new user accounts.

## Remove

If you want to get rid of a user account alltogether, call:

{{< example user_remove >}}

This also removes all roles associated with the user.

## Existence

{{< exist-subcommand-en >}}

{{< example user_exist >}}
