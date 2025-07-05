+++
title = "Role Assignment"
slug = "role-assignment"
weight = 40
description = "Learn how to manage user roles in BOMnipotent Server, including listing, adding, and removing roles, with detailed command examples and permissions."
+++

Roles are what connects users to permissions. Adding or removing roles to and from users indirectly controls to what extend users can interact with your BOMnipotent Server instance.

For your convenience, several [default roles](/client/manager/access-management/role-management/#default-roles) are created upon starting BOMnipotent Server for the first time. In addition, BOMnipotent knows of the [admin role](/client/manager/access-management/role-management/#admin-role), which receives some special treatment.

> To modify or even view user roles, your user account needs the {{<user-management-en>}} permission.

## List

To list all roles of all users, call

{{< example user_role_list >}}

The output can be filtered by user or role:

{{< example user_role_filtered_list >}}

## Add

To add a new role to a user, call

{{< example user_role_add >}}

The user account needs to exist on the server at this point, the role does not.

> Only users with the [admin role](/client/manager/access-management/role-management/#admin-role) can add the admin role to other users.

## Remove

To remove a role from a user, call:

{{< example user_role_remove >}}

This will show an error if either does not exist:

{{< example user_role_remove_wrong >}}

> Only users with the [admin role](/client/manager/access-management/role-management/#admin-role) can remove the admin role from other users.

## Existence

{{< exist-subcommand-en >}}

{{< example user_role_exist >}}
