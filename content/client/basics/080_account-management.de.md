+++
title = "Benutzerkonto Verwaltung"
description = "Anleitung zum Widerruf von Nutzer-Schlüsseln: Schlüsselstatus auf REVOKED setzen, in Datenbank vermerken und Session-Dateien sicher entfernen."
slug = "account-management"
weight = 80
+++

## Schlüssel widerrufen

In einer idealen Welt würde ein Schlüssel, der mit einem Nutzerkonto verknüpft ist, genutzt werden, bis er abläuft. Es kann jedoch durch ein Missgeschick passieren, dass der Schlüssel kompromittiert wird. In diesem Fall muss er widerrufen werden.

Um einen Schlüssel zu widerrufen, benutzen Sie den "user revoke key" Befehl:

{{< example "user_revoke_key" "1.3.0" >}}

Dies setzt den Status des aktuell genutzten Schlüssels auf "REVOKED". Er kann nicht weiter genutzt werden.

{{< example "whoami_revoked_key" "1.3.0" >}}

Der widerrufene Schlüssel wird in der Datenbank behalten. Das stellt sicher, dass er nicht noch einmal in einer späteren Nutzeranfrage verwendet wird:

{{< example "user_request_revoked_key" "1.3.0" >}}

Nachdem Sie einen Schlüssel widerrufen haben, sollten Sie ihn von Ihrem Dateisystem löschen. Sie finden seinen Speicherort in den Session Daten:

{{< example "session_status_revoked_key" >}}
