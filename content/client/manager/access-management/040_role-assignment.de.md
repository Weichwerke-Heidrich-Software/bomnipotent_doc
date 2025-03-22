+++
title = "Rollenzuweisung"
slug = "role-assignment"
weight = 40
description = "Verwalten Sie Benutzerrollen im BOMnipotent-Server: Rollen auflisten, hinzufügen und entfernen. Nur Admins können Admin-Rollen zuweisen oder entfernen."
+++

Rollen verbinden Benutzer mit Berechtigungen. Das Hinzufügen oder Entfernen von Rollen steuert indirekt, in welchem ​​Umfang Benutzer mit Ihrer BOMnipotent Server Instanz interagieren können.

Zu Ihrer Bequemlichkeit werden beim ersten Start des BOMnipotent-Servers mehrere [Standardrollen](/de/client/manager/access-management/role-management/#standardrollen) angelegt. BOMnipotent kennt außerdem die [Administratorrolle](/de/client/manager/access-management/role-management/#admin-rolle), die eine besondere Behandlung erhält.

> Um Benutzerrollen zu ändern oder anzuzeigen, benötigt Ihr Benutzerkonto die Berechtigung {{<user-management-de>}}.

## Auflistung

Um alle Rollen aller Benutzer aufzulisten, rufen Sie
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

## Hinzufügen

Um einem Benutzer eine neue Rolle hinzuzufügen, rufen Sie
```
bomnipotent_client user-role add <EMAIL> <ROLLE>
```

``` {wrap="false" title="Ausgabe"}
[INFO] Added role to user
```

Weder Benutzer noch Rolle müssen zu diesem Zeitpunkt vorhanden sein.

> Nur Benutzer mit der [Admin-Rolle](/de/client/manager/access-management/role-management/#admin-rolle) können anderen Benutzern die Admin-Rolle zuweisen.

## Entfernen

Um einem Benutzer eine Rolle zu entfernen, rufen Sie Folgendes auf:
```
bomnipotent_client user-role remove <EMAIL> <ROLLE>
```

``` {wrap="false" title="Ausgabe"}
[INFO] Removed role bom_manager from user info@wildeheide
```

Wenn eine der beiden Rollen nicht vorhanden ist, wird ein Fehler angezeigt:

``` {wrap="false" title="Ausgabe"}
[ERROR] Received response:
404 Not Found
User with email info@wildeheide does not have role bom_manager
```

> Nur Benutzer mit der [Admin-Rolle](/de/client/manager/access-management/role-management/#admin-rolle) können die Admin-Rolle von anderen Benutzern entfernen.
