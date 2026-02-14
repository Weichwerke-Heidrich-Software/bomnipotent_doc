+++
title = "Permissions"
slug = "permissions"
weight = 10
description = "Learn what permissions exist in BOMnipotent, including consumer, manager, and special admin permissions."
+++

In BOMnipotent, permissions are not directly associated with user accounts, but rather with roles. The section about [role management](/client/manager/access-management/role-management/) covers how this association is managed, and the section about [role assignment](/client/manager/access-management/role-assignment/) explains how roles (and thus ultimately permissions) are assigned to users.

The server has several permissions embedded in its code, some of which are hardcoded, some of which are configurable, and all of which are explained here. To learn how to actually create a permission associated with a role, please refer to the [section](/client/manager/access-management/role-management/) dedicated to exactly that topic.

The permissions can mentally be split into permissions associated with [consumers](#consumer-permissions), [managers](#manager-permissions), and some [special tasks](#special-admin-permissions) reserved for admins.

## Consumer Permissions

Your customers are typically associated with one or more of your products. They will want to view all types of documents and information for that particular product, but they are not automatically entitled to information about other products.

### PRODUCT_ACCESS

A permission with the value "PRODUCT_ACCESS(\<PRODUCT\>)" grants read permissions to any document associated with "\<PRODUCT\>". This includes any BOM for that product, any vulnerabilities associated with these BOMs, and any CSAF documents covering this product.

For example, a role with the "PRODUCT_ACCESS(BOMnipotent)" could view (and only view) all documents associated with BOMnipotent.

It is possible to use the asterisk operator "\*" to glob product names. In that case, the asterisk matches an arbitrary number of symbols. For example, the permission "PRODUCT_ACCESS(BOM\*ent)" would match "BOMnipotent" as well as the (fictional) products "BOMent" and "BOM-burárum-ent", but not "BOMtastic" (because the latter does not end on "ent").

Consequently, "PRODUCT_ACCESS(\*)" allows the viewing of all documents.

## Manager Permissions

For managers of documents, the situation is usually reversed: They need the permission to not only view but also modify the contents in the database. Their scope is typically not restricted to a specific product, but instead to a specific type of document. This is why the segregation of manager permissions takes another perspective.

### BOM_MANAGEMENT

This permission allows the [uploading, modifying and deleting](/client/manager/doc-management/boms/) of Bills of Materials (BOMs). It also automatically grants permission to view all hosted BOMs.

### VULN_MANAGEMENT

This permission allows to [update and view](/client/manager/doc-management/vulnerabilities/) the list of vulnerabilities associated with any BOM.

### CSAF_MANAGEMENT

Unsurprisingly, this permission allows the [uploading, modifying and deleting](/client/manager/doc-management/csaf-docs/) of Common Security Advisory Framework (CSAF) documents. It also automatically grants view permissions to all hosted CSAF documents.

### ROLE_MANAGEMENT

With this permission, a user can [modify the permissions](/client/manager/access-management/role-management/) of roles, which can have far reaching consequences, because the changes potentially affect many users.

### USER_MANAGEMENT

This permission is required to [approve, deny or view](/client/manager/access-management/user-management/) users, or to individually [assign roles](/client/manager/access-management/role-assignment/) to them.

## Special Admin permissions

BOMnipotent knows one hardcoded special role called "admin". This role always has all permissions that can be given to users. Additionally, there are some tasks that can only be done by a user with the admin role:
- Only admins can [give or remove](/client/manager/access-management/role-assignment/) the admin role to or from other users. A special [tmp admin mechanism](/server/setup/admin/) exists to create the first admin for a freshly created BOMnipotent Server.
- Only admins can [(de)activate the subscription key](/client/manager/subscription/) for a BOMnipotent Server instances.
- Only admins can create and restore [database backups](/client/manager/backup-management/).
