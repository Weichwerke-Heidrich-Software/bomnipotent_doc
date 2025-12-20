+++
title = "Authentifizierung"
slug = "authenticating"
weight = 30
description = "Authentifizierung mit BOMnipotent Client: Nutzeraccount-Antrag, Bestätigung, Email und Schlüssel für Serveranfragen, Schlüsselpfad-Option, Nutzersitzung."
+++

> Authentifizierung setzt voraus, dass Sie [einen Nutzeraccount beantragt haben](/de/client/basics/account-creation/), und dass dieser von einem Nutzermanager [bestätigt wurde](/de/client/manager/access-management/user-management/).

Sobald Ihr Account (also ihr Nutzername und ihr öffentlicher Schlüssel) bestätigt ist, können Sie BOMnipotent Client Ihren Nutzernamen mitgeben um eine authentifizierte Anfrage an den Server zu stellen:

{{< example "authenticated_request" "1.1.0" >}}

BOMnipotent Client ließt dann automatisch Ihren geheimen Schlüssel und nutzt ihn zur Authentifizierung.

> Ihr geheimer Schlüssel wird benutzt, um die HTTP Methode, Ihren Nutzernamen, einen Zeitstempel und den Haupttext der Anfrage kryptografisch zu signieren. Dies schützt gleichzeitig davor, dass andere sich als Sie ausgeben, dass Inhalte verändert werden, und vor Replay Attacks. Der geheime Schlüssel erreicht all dies, ohne jemals ihren lokalen Rechner verlassen zu müssen. Die Schönheit des Ganzen würde leider den Umfang dieser Dokumentation sprengen.

Falls Sie Ihren Schlüssel nicht im üblichen Nutzerordner speichern, müssen Sie BOMnipotent Client den Pfad per Kommandozeilenoption angeben:

{{< example "authenticated_request_custom_key" "1.1.0" >}}

Um diese drei zusätzlichen Argumente bei jeder einzelnen Anfrage zu vermeiden, können Sie die Daten stattdessen in einer [Nutzersitzung](/de/client/basics/user-session/) speichern.
