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
```
bomnipotent_client role-permission remove bom_manager BOM_MANAGEMENT;
bomnipotent_client role-permission remove csaf_manager CSAF_MANAGEMENT;
bomnipotent_client role-permission remove role_manager ROLE_MANAGEMENT;
bomnipotent_client role-permission remove user_manager USER_MANAGEMENT;
bomnipotent_client role-permission remove vuln_manager VULN_MANAGEMENT;
```

## Admin-Rolle

Es gibt eine spezielle Rolle namens "admin", die nicht in den anderen Rollen aufgeführt ist. Der Grund dafür ist, dass sie nicht Teil der Datenbank, sondern des BOMnipotent-Codes selbst ist. Daher kann sie nicht geändert werden.

{{< tabs >}}
{{% tab title="Versuch, Berechtigungen zu entfernen" %}}
```
bomnipotent_client role-permission remove admin BOM_MANAGEMENT
```
{{% /tab %}}
{{% tab title="Versuch, Berechtigungen hinzuzufügen" %}}
```
bomnipotent_client role-permission add admin "PRODUCT_ACCESS(BOMnipotent)"
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="Ausgabe"}
[ERROR] Received response:
422 Unprocessable Entity
Cannot modify admin role permissions
```

Die Administratorrolle verfügt über alle Berechtigungen, die erteilt werden können, und dann noch [einige weitere](/de/client/manager/access-management/permissions/#sonderberechtigungen-für-administratoren).

## Auflisten

Um alle Rollen und die zugehörigen Berechtigungen aufzulisten, rufen Sie Folgendes auf:
```
bomnipotent_client role-permission list
```

``` {wrap="false" title="Ausgabe"}
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

Die Ausgabe kann nach Rolle oder Berechtigung gefiltert werden:
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client role-permission list --role=bom_manager --permission=BOM_MANAGEMENT
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client role-permission list -r bom_manager -p BOM_MANAGEMENT
```
{{% /tab %}}
{{< /tabs >}}
``` {wrap="false" title="Ausgabe"}
╭──────────────┬─────────────────┬───────────────────────────╮
│ Role         │ Permission      │ Last Updated              │
├──────────────┼─────────────────┼───────────────────────────┤
│ bom_manager  │ BOM_MANAGEMENT  │ 2025-03-20 10:38:27.29648 │
│              │                 │ 0 UTC                     │
╰──────────────┴─────────────────┴───────────────────────────╯
```

## Hinzufügen

Da Rollen ohne Berechtigungen bedeutungslos sind, werden sie immer paarweise verwendet. Es gibt keinen speziellen Mechanismus zum Erstellen einer neuen Rolle. Stattdessen existiert eine Rolle dadurch, dass ihr eine Berechtigung hinzugefügt wird.

Die Syntax zum Hinzufügen einer Berechtigung zu einer Rolle lautet:
```
bomnipotent_client role-permission add <ROLLE> <BERECHTIGUNG>
```
``` {wrap="false" title="Ausgabe"}
[INFO] Added permission BOM_MANAGEMENT to role
```

Sie könnten beispielsweise mehrere Berechtigungen in den Rollen "doc_manager" und "access_manager" zusammenfassen:
```
bomnipotent_client role-permission add doc_manager BOM_MANAGEMENT;
bomnipotent_client role-permission add doc_manager CSAF_MANAGEMENT;
bomnipotent_client role-permission add doc_manager VULN_MANAGEMENT;
bomnipotent_client role-permission add access_manager ROLE_MANAGEMENT;
bomnipotent_client role-permission add access_manager USER_MANAGEMENT;
```

Falls Sie die [Standardrollen](#standardrollen) wie oben beschrieben entfernt haben, erhalten Sie Folgendes:
```
bomnipotent_client role-permission list
```
``` {wrap="false" title="Ausgabe"}
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

Falls die hinzuzufügende Berechtigung nicht existiert oder fehlerhaft ist, erhalten Sie eine Fehlermeldung:
```
bomnipotent_client role-permission add clam_manager CLAM_MANAGEMENT
```
``` {wrap="false" title="Ausgabe"}
[ERROR] Received response:
422 Unprocessable Entity
Failed to parse permission: Invalid UserPermission string: CLAM_MANAGEMENT
```

## Entfernen

Um eine Berechtigung aus einer Rolle zu entfernen, rufen Sie einfach Folgendes auf:
```
bomnipotent_client role-permission remove <ROLE> <PERMISSION>
```
``` {wrap="false" title="Ausgabe"}
[INFO] Removed permission VULN_MANAGEMENT from role vuln_manager
```

Sobald Sie die letzte Rolle aus einer Berechtigung entfernt haben, existiert diese nicht mehr.

> Um Hoppla-Momente zu vermeiden, unterstützt BOMnipotent nicht das Löschen ganzer Stapel von Rollenberechtigungen.

## Existenz

{{< exists-subcommand-de >}}

{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client role-permission exists --role=bom_manager
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client role-permission exists -r bom_manager
```
{{% /tab %}}
{{< /tabs >}}
