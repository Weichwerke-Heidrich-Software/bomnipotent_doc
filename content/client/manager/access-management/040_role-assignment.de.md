+++
title = "Rollenzuweisung"
slug = "role-assignment"
weight = 40
description = "Verwalten Sie Benutzerrollen im BOMnipotent-Server: Rollen auflisten, hinzufügen und entfernen. Nur Admins können Admin-Rollen zuweisen oder entfernen."
+++

Rollen verbinden Benutzer mit Berechtigungen. Das Hinzufügen oder Entfernen von Rollen steuert indirekt, in welchem ​​Umfang Benutzer mit Ihrer BOMnipotent Server Instanz interagieren können.

Zu Ihrer Bequemlichkeit werden beim ersten Start des BOMnipotent-Servers mehrere [Standardrollen](/de/client/manager/access-management/role-management/#standardrollen) angelegt. BOMnipotent kennt außerdem die [Administratorrolle](/de/client/manager/access-management/role-management/#admin-rolle), die eine besondere Behandlung erhält.

> Um Benutzerrollen zu ändern oder anzuzeigen, benötigt Ihr Benutzerkonto die Berechtigung {{<user-management-de>}}.

## Auflisten

Um alle Rollen aller Benutzer aufzulisten, rufen Sie
{{< example user_role_list >}}

Die Ausgabe kann nach Nutzer oder Rolle gefiltert werden:
{{< example user_role_filtered_list >}}

## Hinzufügen

Um einem Benutzer eine neue Rolle hinzuzufügen, rufen Sie
{{< example user_role_add >}}

Der Benutzeraccount muss zu diesem Zeitpunkt bereits auf dem Server existieren, die Rolle jedoch nicht.

> Nur Benutzer mit der [Admin-Rolle](/de/client/manager/access-management/role-management/#admin-rolle) können anderen Benutzern die Admin-Rolle zuweisen.

## Entfernen

Um einem Benutzer eine Rolle zu entfernen, rufen Sie Folgendes auf:
{{< example user_role_remove >}}

Wenn eine der beiden Rollen nicht vorhanden ist, wird ein Fehler angezeigt:
{{< example user_role_remove_wrong >}}

> Nur Benutzer mit der [Admin-Rolle](/de/client/manager/access-management/role-management/#admin-rolle) können die Admin-Rolle von anderen Benutzern entfernen.

## Existenz

{{< exists-subcommand-de >}}
{{< example user_role_exists >}}
