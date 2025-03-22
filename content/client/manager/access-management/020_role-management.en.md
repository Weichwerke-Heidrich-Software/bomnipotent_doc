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
```
bomnipotent_client role-permission remove bom_manager BOM_MANAGEMENT;
bomnipotent_client role-permission remove csaf_manager CSAF_MANAGEMENT;
bomnipotent_client role-permission remove role_manager ROLE_MANAGEMENT;
bomnipotent_client role-permission remove user_manager USER_MANAGEMENT;
bomnipotent_client role-permission remove vuln_manager VULN_MANAGEMENT;
```

## Admin Role

There is a special role called "admin", which is not listed among the other roles. The reason is that it is not part of the database, but of the BOMnipotent code itself. As such, it cannot be modified.

{{< tabs >}}
{{% tab title="attempting to remove permissions" %}}
```
bomnipotent_client role-permission remove admin BOM_MANAGEMENT
```
{{% /tab %}}
{{% tab title="attempting to add permissions" %}}
```
bomnipotent_client role-permission add admin "PRODUCT_ACCESS(BOMnipotent)"
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[ERROR] Received response:
422 Unprocessable Entity
Cannot modify admin role permissions
```

The admin role has all permissions that can be granted, and then [some more](/client/manager/access-management/permissions/#special-admin-permissions).

## Listing

To list all roles and their associated permissions, call:
```
bomnipotent_client role-permission list
```
``` {wrap="false" title="output"}
╭──────────────┬─────────────────┬───────────────────────────╮
│ Role         │ Permission      │ Last Updated              │
├──────────────┼─────────────────┼───────────────────────────┤
│ bom_manager  │ BOM_MANAGEMENT  │ 2025-03-20 10:38:27.29648 │
│              │                 │ 0 UTC                     │
│ csaf_manager │ CSAF_MANAGEMENT │ 2025-03-20 10:38:27.29695 │
│              │                 │ 2 UTC                     │
│ role_manager │ ROLE_MANAGEMENT │ 2025-03-20 10:38:27.29621 │
│              │                 │ 3 UTC                     │
│ user_manager │ USER_MANAGEMENT │ 2025-03-20 10:38:27.29562 │
│              │                 │ 0 UTC                     │
│ vuln_manager │ VULN_MANAGEMENT │ 2025-03-20 10:38:27.29671 │
│              │                 │ 9 UTC                     │
╰──────────────┴─────────────────┴───────────────────────────╯
```

## Adding

Because roles without permissions are meaningless, the two always come in pairs. There is no dedicated mechanism to create a new role: rather, you add a permission to a role, and henceforth it exists.

The syntax to add a permission to a role is
```
bomnipotent_client role-permission add <ROLE> <PERMISSION>
```
``` {wrap="false" title="output"}
[INFO] Added permission BOM_MANAGEMENT to role
```

You could for example unify several permissions into the roles "doc_manager" and "access_manager":
```
bomnipotent_client role-permission add doc_manager BOM_MANAGEMENT;
bomnipotent_client role-permission add doc_manager CSAF_MANAGEMENT;
bomnipotent_client role-permission add doc_manager VULN_MANAGEMENT;
bomnipotent_client role-permission add access_manager ROLE_MANAGEMENT;
bomnipotent_client role-permission add access_manager USER_MANAGEMENT;
```

If you have removed the [default roles](#default-roles) as described above, this leaves you with:
```
bomnipotent_client role-permission list
```
``` {wrap="false" title="output"}
╭────────────────┬─────────────────┬───────────────────────────╮
│ Role           │ Permission      │ Last Updated              │
├────────────────┼─────────────────┼───────────────────────────┤
│ access_manager │ ROLE_MANAGEMENT │ 2025-03-20 11:05:42.06443 │
│                │                 │ 7 UTC                     │
│ access_manager │ USER_MANAGEMENT │ 2025-03-20 11:04:57.51274 │
│                │                 │ 7 UTC                     │
│ doc_manager    │ BOM_MANAGEMENT  │ 2025-03-20 11:05:55.15986 │
│                │                 │ 0 UTC                     │
│ doc_manager    │ CSAF_MANAGEMENT │ 2025-03-20 11:05:50.92466 │
│                │                 │ 9 UTC                     │
│ doc_manager    │ VULN_MANAGEMENT │ 2025-03-20 11:05:47.35620 │
│                │                 │ 9 UTC                     │
╰────────────────┴─────────────────┴───────────────────────────╯
```

If the permission you want to add does not exist or is malformed, you will receive an error:
```
bomnipotent_client role-permission add clam_manager CLAM_MANAGEMENT
```
``` {wrap="false" title="output"}
[ERROR] Received response:
422 Unprocessable Entity
Failed to parse permission: Invalid UserPermission string: CLAM_MANAGEMENT
```

## Removing

To remove a permission from a role, simply call:
```
bomnipotent_client role-permission remove <ROLE> <PERMISSION>
```
``` {wrap="false" title="output"}
[INFO] Removed permission VULN_MANAGEMENT from role vuln_manager
```

Once you have removed the last role from a permission, that role does no longer exist.

> To prevent oopsie-moments, BOMnipotent does not support deleting whole batches of role-permissions.
