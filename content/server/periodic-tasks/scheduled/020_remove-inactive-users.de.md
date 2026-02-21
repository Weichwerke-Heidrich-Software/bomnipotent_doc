+++
title = "Remove inactive Users"
slug = "remove-inactive-users"
weight = 20
description = "Automatische Entfernung inaktiver Nutzer aus der Datenbank nach 30 Tagen, um DSGVO-konform zu bleiben."
+++

Diese Aufgabe überprüft die Nutzer Datenbank auf Einträge die länger als 30 Tage abgelaufen sind, und entfernt sie.

Dies stellt sicher, dass Sie persönlich identifizierbaren Daten wie Emailadressen nicht länger als benötigt speichern. Dies ist ein zentrales Credo der [Datenschutz Grundverordnung](https://dsgvo-gesetz.de/) (DSGVO) der Europäischen Union.

> [!NOTE] Bleiben Sie konform
> Falls Sie Ihre Dienste in der Europäischen Union anbieten müssen sie DSGVO-konform sein. Schalten sie diese zyklische Aufgabe nicht aus, ohne einen anderen Prozess zu haben um Ihre Datenbank aufzuräumen.

Der Name dieser Aufgabe ist "remove_inactive_users". Sie akzeptiert die folgenden [Konfigurationen](/de/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "remove_inactive_users"
period = "1 day" # Optional
scheduled = true # Optional
```

Die Zeit bis ein abgelaufener Nutzer entfernt wird kann im Abschnitt ["[user]"](/server/configuration/optional/user-expiration-period/#removal-period) konfiguriert werden.
