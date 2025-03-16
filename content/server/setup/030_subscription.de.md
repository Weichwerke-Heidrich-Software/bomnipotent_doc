+++
title = "Aktivieren Ihres Abonnements"
slug = "subscription"
weight = 30
description = "Erfahren Sie, wie Sie Ihren Abonnementschlüssel erhalten, aktivieren und den Status überprüfen."
+++

Die meisten Aktionen, die Daten zu Ihrer BOMnipotent-Datenbank hinzufügen, erfordern ein aktives Abonnement, während das Lesen und Entfernen von Daten dies nicht erfordert. Diese Richtlinie stellt sicher, dass Ihre Benutzer den Zugriff auf die vorhandenen Daten nicht verlieren, falls Sie eines Tages die Zahlung für das Produkt einstellen sollten.

Gewerbliche Einrichtungen wie Unternehmen können ein Abonnement auf [bomnipotent.de](https://www.bomnipotent.de/de/pricing) erwerben. Wenn Sie eine nicht-gewerbliche Einrichtung sind, können Sie BOMnipotent kostenlos nutzen. Sie können den Zugriff anfordern, indem Sie eine E-Mail an [info@wwh-soft.com](mailto:info@wwh-soft.com) senden.

Kurz nachdem Sie ein Abonnement erworben haben, erhalten Sie eine E-Mail mit Ihrem Abonnementschlüssel.

Abonnements können nur von einem Benutzer mit der Rolle "Administrator" verwaltet werden. [Erstellen Sie eines](/de/server/setup/admin/), falls Sie dies noch nicht getan haben.

Als dieser Benutzer angemeldet, rufen Sie:
```
bomnipotent_client subscription activate <Ihr Abonnementschlüssel>
```
``` {wrap="false" title="output"}
[INFO] Successfully stored subscription key.
```

Um den aktuellen Status Ihres Abonnements zu überprüfen, führen Sie Folgendes aus:
```
bomnipotent_client subscription status
```
``` {wrap="false" title="output"}
╭──────────┬───────────────────────────┬─────────────────────┬─────────────────────────┬─────────────────────────┬───────────────────────────╮
│ Key      │ Product                   │ Subscription Status │ Valid Until             │ Last Updated            │ Assessment                │
├──────────┼───────────────────────────┼─────────────────────┼─────────────────────────┼─────────────────────────┼───────────────────────────┤
│ ***qcgy2 │ pro_01jg3k3ndmpmyx9z7he86 │ active              │ 2026-03-01 04:19:13 UTC │ 2025-03-01 04:19:13 UTC │ The Subscription is valid │
│          │ z5430                     │                     │                         │                         │                           │
╰──────────┴───────────────────────────┴─────────────────────┴─────────────────────────┴─────────────────────────┴───────────────────────────╯
```
