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

{{< example subscription_activate >}}

Der Server benachrichtigt Sie, falls bei der Aktivierung ein Fehler auftritt:

{{< example subscription_activate_wrong >}}

## Status

Um Informationen über den aktuellen Status Ihres Abonnements zu erhalten, rufen Sie:

{{< example subscription_status >}}

Diese Ausgabe enthält eine verschleierte Variante Ihres Schlüssels, einen Status und einige zusätzliche Informationen.

## Entfernen

Wenn Sie Ihr Abonnement von einer Instanz des BOMnipotent-Servers entfernen möchten (z. B. weil Sie es für eine andere Instanz verwenden möchten), rufen Sie Folgendes auf:

{{< example subscription_remove >}}

Um zu vermeiden, dass eine BOMnipotent-Serverinstanz, auf die Sie Administratorzugriff haben, versehentlich deaktiviert wird, ist der korrekte Schlüssel als Argument erforderlich.

{{< example subscription_remove_wrong >}}
