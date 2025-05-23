+++
title = "Nutzerverwaltung"
slug = "user-management"
weight = 30
description = "Erfahren Sie, wie Sie Benutzerkonten in BOMnipotent verwalten: Benutzer auflisten, genehmigen, ablehnen und löschen. Schritt-für-Schritt-Anleitungen inklusive."
+++

Der erste Schritt beim Anlegen eines neuen Benutzers ist die Beantragung eines neuen Kontos. Dieser Schritt wird [an anderer Stelle](/de/client/basics/account-creation/) beschrieben, da er sowohl für Manager als auch für Konsumenten relevant ist.

Aus Sicht von BOMnipotent ist ein Benutzer verknüpft mit einer eindeutigen E-Mail-Adresse als Kennung, und einem öffentlichen Schlüssel zur Authentifizierung. Dies sind alle Daten, die bei der Erstellung eines neuen Benutzerkontos gesendet werden.

Nach der Beantragung eines neuen Kontos obliegt es einem Benutzermanager, die Anfrage zu genehmigen oder abzulehnen.

> Für die meisten Benutzerinteraktionen, einschließlich der Auflistung, benötigen Sie die Berechtigung {{<user-management-de>}}.

## Auflistung

Um alle Benutzer in Ihrer Datenbank aufzulisten, rufen Sie
```
bomnipotent_client user list
```

``` {wrap="false" title="Ausgabe"}
╭────────────────────┬───────────┬─────────────────────────┬─────────────────────────╮
│ User Email         │ Status    │ Expires                 │ Last Updated            │
├────────────────────┼───────────┼─────────────────────────┼─────────────────────────┤
│ admin@wwh-soft.com │ APPROVED  │ 2026-03-23 04:51:26 UTC │ 2025-03-22 04:51:26 UTC │
│ info@wildeheide.de │ VERIFIED  │ 2026-03-23 03:52:21 UTC │ 2025-03-22 03:52:21 UTC │
╰────────────────────┴───────────┴─────────────────────────┴─────────────────────────╯
```

So können Sie die E-Mail-Adressen und die Stati der Benutzer einsehen.

> Ein Benutzer ohne den Status "APPROVED" hat keine besonderen Berechtigungen, unabhängig von zugewiesenen Rollen.

Jedem Benutzer ist außerdem ein Ablaufdatum zugeordnet. Ab diesem Zeitpunkt wird der öffentliche Schlüssel ungültig und muss erneuert werden. Die Gültigkeitsdauer eines Schlüssels kann in der Serverkonfiguration [frei konfiguriert](/de/server/configuration/optional/user-expiration-period/) werden.

## Genehmigung oder Ablehnung

Wenn Sie die Benutzeranfrage erwartet haben, können Sie sie genehmigen:
```
bomnipotent_client user approve <EMAIL>
```

``` {wrap="false" title="Ausgabe"}
[INFO] Changed status of info@wildeheide.de to APPROVED
```

Falls der Nutzer noch nicht bestätigt hat, Zugriff auf die Email Adresse zu haben, dann lehnt der Server die Genehmigung ab. Falls Sie absolut sicher sind, dass Sie wissen was Sie tun, können Sie dieses Verhalten mit der '--allow-unverified' Option überschreiben (es gibt keine Kurzformen für Befehle die Sicherheitsmaßnahmen überschreiben):
```
bomnipotent_client user approve <EMAIL> --allow-unverified
```

Falls das Konto zu einem Roboter gehört, kann es nicht verifiziert werden. In diesem Fall können Sie es mit der ' --robot' Option genehmigen:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client user approve <Nutzername> --robot
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client user approve <Nutzername> -r
```
{{% /tab %}}
{{< /tabs >}}

> **Wichtig:** Sie sollten absolut sicher sein, dass dies das Konto ist, welches Sie genehmigen wollen.

Analog dazu können Sie diesem Benutzer stattdessen keinen Zugriff gewähren:
```
bomnipotent_client user deny <EMAIL>
```

``` {wrap="false" title="output"}
[INFO] Changed status of info@wildeheide.de to DENIED
```

Im Gegensatz zum Genehmigen ist es dieser Aktion egal, welchen Status das Konto vor der Ablehnung hatte.

> Es ist möglich, einem bereits genehmigten Benutzer den Zugriff wieder zu verweigern, wodurch das Konto effektiv widerrufen wird.

## Entfernen

Wenn Sie ein Benutzerkonto vollständig löschen möchten, rufen Sie
```
bomnipotent_client user remove <EMAIL>
```

``` {wrap="false" title="output"}
[INFO] Deleted user info@wildeheide.de
```

Dies löscht zusätzlich alle dem Benutzer zugewiesenen Rollen.
