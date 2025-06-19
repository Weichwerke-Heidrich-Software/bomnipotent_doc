+++
title = "Admin erstellen"
slug = "admin"
weight = 20
description = "Erfahren Sie, wie Sie einen Admin-Benutzer in BOMnipotent erstellen und verwalten, einschließlich der Schritte zu temporären und dauerhaften Admin-Rechten."
+++

Für einige Interaktionen mit BOMnipotent ist ein Benutzer mit Administratorrechten erforderlich. Eine davon ist die Gewährung von Administratorrechten an einen neuen Benutzer. Dies bedeutet, dass eine Art Bootstrapping-Mechanismus erforderlich ist.

## Schritt 1: Benutzer erstellen
Zuerst müssen Sie [ein Benutzerkonto erstellen](/de/client/basics/account-creation):

{{< example admin_user_request >}}

Sobald Sie Ihre Email Adresse bestätigt haben, können Sie dies in den Logs sehen.

{{< example admin_email_verification >}}

Um etwas Arbeit beim Tippen zu sparen, speichern Sie die Domäne Ihres Servers und Ihre E-Mail-Adresse in einer [Benutzersitzung](/client/basics/user-session/):

{{< example admin_session_login >}}

## Schritt 2: Benutzer als TMP-Administrator markieren

> Aus Sicherheitsgründen muss der Benutzer zu diesem Zeitpunkt bereits in der Datenbank vorhanden sein. Andernfalls könnte ein böswilliger Akteur die E-Mail-Adresse, die Sie für Ihren Administrator verwenden, erraten und zu einem geeigneten Zeitpunkt eine eigene Anfrage stellen. Um dies zu verhindern, blockiert der TMP-Admin-Mechanismus alle Anfragen, diesen bestimmten Benutzer neu zur Datenbank hinzuzufügen.

Als Nächstes werden Sie zu dem Benutzermanager, der in der Serverantwort erwähnt wurde: Melden Sie sich bei Ihrem Servercomputer an und stellen Sie in Ihrer Serverkonfigurationsdatei die folgende Zeile an den Anfang:
```toml
tmp_admin = "admin@example.com"
```

>  Es ist wichtig, diese Zeile **am Anfang** der Datei hinzuzufügen, da BOMnipotent sonst versuchen könnte, dieses Feld als Teil eines anderen Abschnitts zu interpretieren.

Ihre Serverprotokolle sollten jetzt zeigen, dass die Konfiguration zusätzlich zu der Benutzeranfrage, die Sie zuvor gestellt haben, neu geladen wurde.

```
docker logs bomnipotent_server
```
``` {wrap="false" title="output"}
...
2025-03-06 11:30:15 +00:00 [INFO] Received POST request from 101.102.103.104 to https://bomnipotent.wwh-soft.com/user/info@wwh-soft.com
2025-03-06 11:32:56 +00:00 [INFO] Configuration successfully reloaded from "/etc/bomnipotent_server/configs/config.toml"
...
```

## Schritt 3: Benutzer zum Volladministrator machen

Der Server behandelt authentifizierte Anfragen dieses Benutzers jetzt so, als wäre die Person ein Administrator. Um dauerhafter Administrator zu werden, müssen Sie zuerst Ihre Benutzeranfrage genehmigen. Zurück auf dem Client rufen Sie:

{{< example admin_user_approve >}}

Jetzt können Sie sich selbst zum vollwertigen Serveradministrator machen:

{{< example admin_user_role_add >}}

## Schritt 4: TMP-Administratormarkierung entfernen

Der Status eines temporären Administrators soll, nun ja, temporär sein. Der Server protokolliert eine Warnung, wenn Sie temporäre Zugriffsrechte verwenden:
```
docker logs bomnipotent_server -n 4
```
``` {wrap="false" title="output"}
2025-03-06 14:51:35 +00:00 [INFO] Received POST request from info@wwh-soft.com to https://bomnipotent.wwh-soft.com/user/info@wwh-soft.com/roles
2025-03-06 14:51:35 +00:00 [WARN] Temporary admin functionality is enabled for info@wwh-soft.com
2025-03-06 14:51:35 +00:00 [INFO] User info@wwh-soft.com was authenticated as a temporary admin
2025-03-06 14:51:35 +00:00 [INFO] Temporary admin info@wwh-soft.com has permission USER_MANAGEMENT to perform this action
```

Aber nachdem Sie sich nun erfolgreich zum permanenten Admin gemacht haben, können und sollten Sie das Feld "tmp_admin" wieder aus der Konfigurationsdatei entfernen.

Sie sind nun bereit, [Ihr Abonnement zu aktivieren](/de/server/setup/subscription/).
