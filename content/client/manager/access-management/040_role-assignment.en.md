+++
title = "Role Assignment"
slug = "role-assignment"
weight = 40
description = "Learn how to manage user roles in BOMnipotent Server, including listing, adding, and removing roles, with detailed command examples and permissions."
+++

Roles are what connects users to permissions. Adding or removing roles to and from users indirectly controls to what extend users can interact with your BOMnipotent Server instance.

For your convenience, several [default roles](/client/manager/access-management/role-management/#default-roles) are created upon starting BOMnipotent Server for the first time. In addition, BOMnipotent knows of the [admin role](/client/manager/access-management/role-management/#admin-role), which receives some special treatment.

> To modify or even view user roles, your user account needs the {{<user-management-en>}} permission.

## Listing

To list all roles of all users, call
```
bomnipotent_client user-role list
```

``` {wrap="false" title="output"}
╭──────────────────┬─────────────┬───────────────────────────╮
│ User Email       │ User Role   │ Last Updated              │
├──────────────────┼─────────────┼───────────────────────────┤
│ info@quantumwire │ bom_manager │ 2025-03-22 04:27:33.71579 │
│                  │             │ 7 UTC                     │
│ info@wildeheide  │ bom_manager │ 2025-03-22 04:26:08.83708 │
│                  │             │ 3 UTC                     │
╰──────────────────┴─────────────┴───────────────────────────╯
```

The output can be filtered by user or role:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client user-role list --user=info@quantumwire --role=bom_manager
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client user-role list -u info@quantumwire -r bom_manager
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
╭──────────────────┬─────────────┬───────────────────────────╮
│ User Email       │ User Role   │ Last Updated              │
├──────────────────┼─────────────┼───────────────────────────┤
│ info@quantumwire │ bom_manager │ 2025-03-22 04:27:33.71579 │
│                  │             │ 7 UTC                     │
╰──────────────────┴─────────────┴───────────────────────────╯
```

## Adding

To add a new role to a user, call
```
bomnipotent_client user-role add <EMAIL> <ROLE>
```

``` {wrap="false" title="output"}
[INFO] Added role to user
```

The user account needs to exist on the server at this point, the role does not.

> Only users with the [admin role](/client/manager/access-management/role-management/#admin-role) can add the admin role to other users.

## Removing

To remove a role from a user, call
```
bomnipotent_client user-role remove <EMAIL> <ROLE>
```

``` {wrap="false" title="output"}
[INFO] Removed role bom_manager from user info@wildeheide
```

This will show an error if either does not exist:

``` {wrap="false" title="output"}
[ERROR] Received response:
404 Not Found
User with username "info@wildeheide" does not have role bom_manager.
```

> Only users with the [admin role](/client/manager/access-management/role-management/#admin-role) can remove the admin role from other users.
