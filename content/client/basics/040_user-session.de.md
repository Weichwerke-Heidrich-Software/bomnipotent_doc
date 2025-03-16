+++
title = "Benutzersitzung"
slug = "user-session"
weight = 40
description = "Anleitung zur Verwaltung von Benutzersitzungen im BOMnipotent Client, einschließlich Anmeldung, Parameterüberschreibung, Statusanzeige und Abmeldung."
+++

## Anmeldung

Der BOMnipotent Client bietet mehrere globale optionale Argumente. Um diese nicht immer wieder angeben zu müssen, können Sie den Anmeldebefehl verwenden, um sie in einer Benutzersitzung zu speichern:
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --domain=<Server> --email=<Ihre-Email> --output=<Modus> --secret-key=<Pfad/zum/Schlüssel> --trusted-root=<Pfad/zum/Zertifikat> login
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -d <Server> -e <Ihre-Email> -o <Modus> -s <Pfad/zum/Schlüssel> -t <Pfad/zum/Zertifikat> login
```
{{% /tab %}}
{{< /tabs >}}

Dies erstellt eine Datei im lokalen Benutzerordner, die die angegebenen Parameter speichert.
``` {wrap="false" title="output"}
[INFO] Storing session data in /home/simon/.config/bomnipotent/session.toml
```

Wann immer Sie den BOMnipotent Client von nun an aufrufen, werden diese Parameter automatisch verwendet:

```
bomnipotent_client bom list # Wird automatisch die angegebene Domain kontaktieren und Ihre Authentifizierungsdaten verwenden.
```

## Parameter überschreiben

Wenn Sie angemeldet sind und bei einem Aufruf des BOMnipotent Clients globale optionale Parameter angeben, werden diese stattdessen verwendet:
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --domain=<anderer-Server> bom list # Wird den andereren Server kontaktieren
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -d <anderer-Server> bom list # Wird den andereren Server kontaktieren
```
{{% /tab %}}
{{< /tabs >}}

Um die im Sitzungsspeicher gespeicherten Daten dauerhaft zu ändern, melden Sie sich einfach erneut mit den neuen Parametern an.

Dies kann auch verwendet werden, um Parameter zu entfernen, indem Sie sie einfach nicht angeben: 
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --domain=<anderer-Server> --email=<Ihre-Email> --output=<mode> login # Setzt secret-key und trusted-root zurück.
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -d <anderer-Server> -e <Ihre-Email> -o <Modus> login # Setzt secret-key und trusted-root zurück.
```
{{% /tab %}}
{{< /tabs >}}

## Status

Um die Parameter der aktuellen Sitzung auszugeben, rufen Sie:
```
bomnipotent_client session status
```

Die Ausgabe ist im [TOML Format](https://toml.io/en/) (so wie die Daten auch auf Ihrem Dateisystem gespeichert sind):
``` toml {wrap="false" title="Ausgabe"}
domain = "https://localhost:62443"
email = "admin@wwh-soft.com"
secret_key_path = "/home/simon/git/bomnipotent/test_cryptofiles/admin"
trusted_root_path = "/home/simon/git/bomnipotent/test_cryptofiles/ca.crt"
```

Falls Sie JSON bevorzugen, fügen Sie einfach die "--json" Option hinzu:
{{< tabs >}}
{{% tab title="long" %}}
```
./bomnipotent_client session status --json
```
{{% /tab %}}
{{% tab title="short" %}}
```
./bomnipotent_client session status -j
```
{{% /tab %}}
{{< /tabs >}}

``` json {wrap="false" title="output"}
{
  "domain": "https://localhost:62443",
  "email": "admin@wwh-soft.com",
  "secret_key_path": "/home/simon/git/bomnipotent/test_cryptofiles/admin",
  "trusted_root_path": "/home/simon/git/bomnipotent/test_cryptofiles/ca.crt"
}
```

Falls Sie nicht eingeloggt sind, erhalten sie einen informativen Trace und einen leeren TOML/JSON Output:
{{< tabs >}}
{{% tab title="output (toml)" %}}
```
[INFO] No session data is currently stored

```
{{% /tab %}}
{{% tab title="output (json)" %}}
```
[INFO] No session data is currently stored
{}
```
{{% /tab %}}
{{< /tabs >}}

Falls Sie diesen Befehl verwenden möchten, um programmatisch zu prüfen, ob Sitzungsdaten gespeichert sind, verwenden Sie zum Beispiel den "raw" Ausgabemodus um den Info Trace zu vermeiden, und prüfen Sie, ob die Ausgabe leer ist:

{{< tabs >}}
{{% tab title="bash" %}}
``` bash
#!/bin/bash

output=$(./bomnipotent_client --output raw session status)
if [ -n "$output" ]; then
    echo "Found session data:"
    echo "$output"
else
    echo "Session not logged in."
fi
```
{{% /tab %}}
{{% tab title="powershell" %}}
``` ps1
$output = ./bomnipotent_client --output raw session status
if ($output) {
    Write-Output "Found session data:"
    Write-Output $output
} else {
    Write-Output "Session not logged in."
}
```
{{% /tab %}}
{{< /tabs >}}


## Abmeldung

Um alle Parameter zu entfernen, rufen Sie logout auf:
```
bomnipotent_client logout
```
Dies entfernt die Sitzungsdatei.
