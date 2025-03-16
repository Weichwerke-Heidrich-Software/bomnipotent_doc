+++
title = "Access Management"
weight = 30
+++

Supply chain security documents are the what of BOMnipotent, users are the who. Unless you explicitly state otherwise, the hosted documents are only visible to those user accounts you grant access to.

BOMnipotent uses role-based access control (RBAC): Users have roles, and roles have [permissions](/client/manager/access-management/permissions/). After setup, BOMnipotent contains a few default roles. These are sufficient for managing the server, but to start accepting user request, you will probably want to [create](/client/manager/access-management/role-management/) at least one new role.

Once that is done, a typical workflow for introducing a new user to your BOMnipotent system is as follows:
1. A new user [requests access](/client/basics/account-creation/) to your server. During this step, BOMnipotent Client sends a public key associated with the account to your server, where it is stored and marked as "requested".
1. You [approve or deny](/client/manager/access-management/user-approval/) the request. The new user account is now accepted as valid, but it does not have any permissions yet.
1. You [assign](/client/manager/access-management/role-assignment/) one or more roles to the new user account.
