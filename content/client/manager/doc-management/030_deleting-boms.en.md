+++
title = "Deleting BOMs"
slug = "deleting-boms"
weight = 30
+++

> For BOM interactions beyond reading, you need the BOM_MANAGEMENT permission. The [User Management Section](/client/manager/user-management/) describes how it is granted.

Deleting a BOM is very straightforward:
```bash
bomnipotent_client bom delete <name> <version>
```

If the BOM does not exist, the server will return 404 Not Found. If it does exists, it is removed from the database.
