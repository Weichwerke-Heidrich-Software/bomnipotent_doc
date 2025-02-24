+++
title = "Authentifizierung"
slug = "authenticating"
weight = 30
+++

> Authentifizierung setzt voraus, dass Sie [einen Nutzeraccount beantragt haben](/de/client/basics/account-creation/), und dass dieser von einem Nutzermanager [bestätigt wurde](/de/client/manager/user-management/user-approval/).

Sobald Ihr Account (also ihre Email und ihr öffentlicher Schlüssel) bestätigt ist, können Sie BOMnipotent Client Ihre Email mitgeben um eine authentifizierte Anfrage an den Server zu stellen:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --domain=<Server> --email=<Ihre-Email> <Kommando>
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -d <Server> -e <Ihre-Email> <Kommando>
```
{{% /tab %}}
{{< /tabs >}}

BOMnipotent Client ließt dann automatisch Ihren geheimen Schlüssel und nutzt ihn zur Authentifizierung.

> Ihr geheimer Schlüssel wird benutzt, um die HTTP Methode, Ihre Email, einen Zeitstempel und den Haupttext der Anfrage kryptografisch zu signieren. Dies schützt gleichzeitig davor, dass andere sich als Sie ausgeben, dass Inhalte verändert werden, und vor Replay Attacks. Der geheime Schlüssel erreicht all dies, ohne jemals ihren lokalen Rechner verlassen zu müssen. Die Schönheit des Ganzen würde leider den Umfang dieser Dokumentation sprengen.

Falls Sie Ihren Schlüssel nicht im üblichen Nutzerordner speichern, müssen Sie BOMnipotent Client den Pfad per Kommandozeilenoption angeben:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --domain=<Server> --email=<Ihre-Email> --secret-key=<Pfad/zum/Schlüssel> <Kommando>
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -d <Server> -e <Ihre-Email> -s <Pfad/zum/Schlüssel> <Kommando>
```
{{% /tab %}}
{{< /tabs >}}

Um diese drei zusätzlichen Argumente bei jeder einzelnen Anfrage zu vermeiden, können Sie die Daten stattdessen in einer [Nutzersitzung](/de/client/basics/user-session/) speichern.
