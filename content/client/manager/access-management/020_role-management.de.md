+++
title = "Rollenverwaltung"
slug = "role-management"
weight = 20
description = "Verwalten Sie Rollen und Berechtigungen in BOMnipotent mit einem rollenbasierten Zugriffsmodell (RBAC). Erfahren Sie, wie Sie Standardrollen anpassen."
+++

BOMnipotent verwendet ein rollenbasiertes Zugriffsmodell (RBAC), bei dem Benutzer Rollen und Rollen Berechtigungen zugeordnet werden. Während [Berechtigungen](/de/client/manager/access-management/permissions/) in BOMnipotent größtenteils fest kodiert sind, können Rollen (fast) frei verwaltet werden. Dieser Abschnitt erklärt, wie das geht.

> Um Rollen und ihre Berechtigungen zu ändern oder anzuzeigen, benötigt Ihr Benutzerkonto die Berechtigung {{<role-management-de>}}.

## Standardrollen

Beim ersten Start Ihres BOMnipotent Servers werden in der Datenbank mehrere kreativ benannte Standardrollen angelegt:
- "bom_manager" mit der Berechtigung {{<bom-management-de>}}.
- "csaf_manager" mit der Berechtigung {{<csaf-management-de>}}.
- "role_manager" mit der Berechtigung {{<role-management-de>}}.
- "user_manager" mit der Berechtigung {{<user-management-de>}}.
- "vuln_manager", mit der Berechtigung {{<vuln-management-de>}}.

Sie können diese Rollen nach Belieben ändern oder löschen; es handelt sich lediglich um Vorschläge.

Wenn Ihnen diese Rollen nicht gefallen, können Sie sie mit den folgenden Aufrufen löschen:

{{< example remove_default_roles >}}

## Admin-Rolle

Es gibt eine spezielle Rolle namens "admin", die nicht in den anderen Rollen aufgeführt ist. Der Grund dafür ist, dass sie nicht Teil der Datenbank, sondern des BOMnipotent-Codes selbst ist. Daher kann sie nicht geändert werden.

{{< example remove_admin_permission >}}

Die Administratorrolle verfügt über alle Berechtigungen, die erteilt werden können, und dann noch [einige weitere](/de/client/manager/access-management/permissions/#sonderberechtigungen-für-administratoren).

## Auflisten

Um alle Rollen und die zugehörigen Berechtigungen aufzulisten, rufen Sie Folgendes auf:

{{< example role_permission_list >}}

Die Ausgabe kann nach Rolle oder Berechtigung gefiltert werden:

{{< example role_permission_filtered_list >}}

## Hinzufügen

Da Rollen ohne Berechtigungen bedeutungslos sind, werden sie immer paarweise verwendet. Es gibt keinen speziellen Mechanismus zum Erstellen einer neuen Rolle. Stattdessen existiert eine Rolle dadurch, dass ihr eine Berechtigung hinzugefügt wird.

Die Syntax zum Hinzufügen einer Berechtigung zu einer Rolle lautet:

{{< example role_permission_add >}}

Sie könnten beispielsweise mehrere Berechtigungen in den Rollen "doc_manager" und "access_manager" zusammenfassen:

{{< example add_doc_and_access_manager >}}

Falls Sie die [Standardrollen](#standardrollen) wie oben beschrieben entfernt haben, erhalten Sie damit folgenden Zustand:

{{< example list_doc_and_access_manager >}}

Falls die hinzuzufügende Berechtigung nicht existiert oder fehlerhaft ist, erhalten Sie eine Fehlermeldung:

{{< example role_permission_add_wrong >}}

## Entfernen

Um eine Berechtigung aus einer Rolle zu entfernen, rufen Sie einfach Folgendes auf:

{{< example role_permission_remove >}}

Sobald Sie die letzte Rolle aus einer Berechtigung entfernt haben, existiert diese nicht mehr.

> Um Hoppla-Momente zu vermeiden, unterstützt BOMnipotent nicht das Löschen ganzer Stapel von Rollenberechtigungen.

## Existenz

{{< exists-subcommand-de >}}

{{< example role_permission_exists >}}
