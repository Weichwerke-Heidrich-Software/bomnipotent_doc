+++
title = "Role Management"
slug = "role-management"
weight = 20
description = "Learn how to manage roles and permissions in BOMnipotent using role-based access control (RBAC). Modify, add, or remove roles and permissions easily."
+++

BOMnipotent uses a role-based access model (RBAC), in which users are associated with roles, and roles with permissions. While [permissions](/client/manager/access-management/permissions/) are largely hardcoded into BOMnipotent, roles can be managed (almost) freely. This section explains how to do that.

> To modify or even view roles and their permissions, your user account needs the {{<role-management-en>}} permission.

## Default Roles

When you spin up your BOMnipotent Server for the first time, it creates several colourfully named default roles in the database:
- "bom_manager", with the {{<bom-management-en>}} permission.
- "csaf_manager", with the {{<csaf-management-en>}} permission.
- "role_manager", with the {{<role-management-en>}} permission.
- "user_manager", with the {{<user-management-en>}} permission.
- "vuln_manager", with the {{<vuln-management-en>}} permission.

You can modify or delete these roles at will, they are merely suggestions.

If you do not like these roles, use the following calls to delete them:

{{< example remove_default_roles >}}

## Admin Role

There is a special role called "admin", which is not listed among the other roles. The reason is that it is not part of the database, but of the BOMnipotent code itself. As such, it cannot be modified.

{{< example remove_admin_permission >}}

The admin role has all permissions that can be granted, and then [some more](/client/manager/access-management/permissions/#special-admin-permissions).

## List

To list all roles and their associated permissions, call:

{{< example role_permission_list >}}

The output can be filtered by role or permission:

{{< example role_permission_filtered_list >}}

## Add

Because roles without permissions are meaningless, the two always come in pairs. There is no dedicated mechanism to create a new role: rather, you add a permission to a role, and henceforth it exists.

The syntax to add a permission to a role is

{{< example role_permission_add >}}

You could for example unify several permissions into the roles "doc_manager" and "access_manager":

{{< example add_doc_and_access_manager >}}

If you have removed the [default roles](#default-roles) as described above, this leaves you with:

{{< example list_doc_and_access_manager >}}

If the permission you want to add does not exist or is malformed, you will receive an error:

{{< example role_permission_add_wrong >}}

## Remove

To remove a permission from a role, simply call:

{{< example role_permission_remove >}}

Once you have removed the last role from a permission, that role does no longer exist.

> To prevent oopsie-moments, BOMnipotent does not support deleting whole batches of role-permissions.

## Existence

{{< exist-subcommand-en >}}

{{< example role_permission_exist >}}
