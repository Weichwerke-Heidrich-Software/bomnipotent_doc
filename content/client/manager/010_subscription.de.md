+++
title = "Abonnementverwaltung"
slug = "subscription"
weight = 10
description = "Aktivieren, prüfen und entfernen Sie Ihren BOMnipotent Abonnementenschlüssel."
+++

Die meisten Aktionen, die Daten zu Ihrer BOMnipotent-Datenbank hinzufügen, erfordern ein aktives Abonnement. Das Lesen und Entfernen von Daten hingegen nicht. Diese Richtlinie stellt sicher, dass Ihre Nutzer den Zugriff auf die vorhandenen Daten nicht verlieren, falls Sie das Produkt nicht mehr bezahlen möchten.

Gewerbliche Unternehmen wie Firmen können ein Abonnement auf [bomnipotent.de](https://www.bomnipotent.de/de/pricing) erwerben. Nicht-gewerbliche Unternehmen können BOMnipotent kostenlos nutzen. Fordern Sie dafür den Zugriff per E-Mail an [info@wwh-soft.com](mailto:info@wwh-soft.com) an.

> Auf dieser Seite wird beschrieben, wie Sie mit dem BOMnipotent-Client und Ihrem **Abonnementschlüssel** eine Instanz des BOMnipotent-Servers (de-)aktivieren. Das Abonnement selbst, d. h. Zahlung, Validierung und Testphase, wird von der externen Firma Paddle abgewickelt. Eine Beschreibung der Verwaltung dieser Aspekte würde den Rahmen dieser Dokumentation sprengen. Bei Fragen wenden Sie sich bitte an [die Hilfeseite](https://www.paddle.com/help) von Paddle.

Kurz nach Abschluss Ihres Abonnements erhalten Sie eine E-Mail mit Ihrem Abonnementschlüssel.

> Abonnements können nur von Benutzern mit der Rolle "Administrator" verwaltet werden.

## Aktivieren

Um Ihr neues Abonnement zu aktivieren, rufen Sie einfach Folgendes auf:
```
bomnipotent_client subscription activate <IHR-ABONNEMENTSCHLÜSSEL>
```
``` {wrap="false" title="Ausgabe"}
[INFO] Successfully stored subscription key.
```

Der Server benachrichtigt Sie, falls bei der Aktivierung ein Fehler auftritt:
``` {wrap="false" title="Ausgabe"}
[ERROR] Received response:
404 Not Found
Failed to activate subscription key: The subscription is missing in the sever database. Please visit https://www.wwh-soft.com to acquire it.
```

## Status

Um Informationen über den aktuellen Status Ihres Abonnements zu erhalten, rufen Sie:
```
bomnipotent_client subscription status
```
``` {wrap="false" title="Ausgabe"}
╭──────────┬───────────────────────────┬─────────────────────┬─────────────────────────┬─────────────────────────┬───────────────────────────╮
│ Key      │ Product                   │ Subscription Status │ Valid Until             │ Last Updated            │ Assessment                │
├──────────┼───────────────────────────┼─────────────────────┼─────────────────────────┼─────────────────────────┼───────────────────────────┤
│ ***qcgy2 │ pro_01jg3k3ndmpmyx9z7he86 │ active              │ 2026-03-01 04:19:13 UTC │ 2025-03-01 04:19:13 UTC │ The Subscription is valid │
│          │ z5430                     │                     │                         │                         │                           │
╰──────────┴───────────────────────────┴─────────────────────┴─────────────────────────┴─────────────────────────┴───────────────────────────╯
```

Diese Ausgabe enthält eine verschleierte Variante Ihres Schlüssels, einen Status und einige zusätzliche Informationen.

## Entfernen

Wenn Sie Ihr Abonnement von einer Instanz des BOMnipotent-Servers entfernen möchten (z. B. weil Sie es für eine andere Instanz verwenden möchten), rufen Sie Folgendes auf:
```
bomnipotent_client subscription remove <IHR-ABONNEMENTSCHLÜSSEL>
```
``` {wrap="false" title="Ausgabe"}
[INFO] Subscription key was removed
```

Um zu vermeiden, dass eine BOMnipotent-Serverinstanz, auf die Sie Administratorzugriff haben, versehentlich deaktiviert wird, ist der korrekte Schlüssel als Argument erforderlich.
