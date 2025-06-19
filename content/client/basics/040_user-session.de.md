+++
title = "Benutzersitzung"
slug = "user-session"
weight = 40
description = "Anleitung zur Verwaltung von Benutzersitzungen im BOMnipotent Client, einschließlich Anmeldung, Parameterüberschreibung, Statusanzeige und Abmeldung."
+++

## Anmeldung

Der BOMnipotent Client bietet mehrere globale optionale Argumente. Um diese nicht immer wieder angeben zu müssen, können Sie den session login Befehl verwenden, um sie in einer Benutzersitzung zu speichern. Dies erstellt eine Datei im lokalen Benutzerordner, die die angegebenen Parameter speichert.

{{< example session_login >}}

Wann immer Sie den BOMnipotent Client von nun an aufrufen, werden diese Parameter automatisch verwendet.

Jegliche relativen Dateipfade, die Sie hierbei angeben, werden vor dem Speichern in absolute Pfade umgewandelt. Somit können Sie die Sitzungsdaten von überall auf Ihrem Computer nutzen.

## Parameter überschreiben

Wenn Sie angemeldet sind und bei einem Aufruf des BOMnipotent Clients globale optionale Parameter angeben, werden diese stattdessen verwendet:

{{< example session_override >}}

Um die im Sitzungsspeicher gespeicherten Daten dauerhaft zu ändern, melden Sie sich einfach erneut mit den neuen Parametern an.

Dies kann auch verwendet werden, um Parameter zu entfernen, indem Sie sie einfach nicht angeben: 

{{< example session_remove_parameters >}}

## Status

Um die Parameter der aktuellen Sitzung auszugeben, rufen Sie "session status". Die Ausgabe ist im [TOML Format](https://toml.io/en/) (so wie die Daten auch auf Ihrem Dateisystem gespeichert sind):

{{< example session_status >}}

Falls Sie JSON bevorzugen, fügen Sie einfach die "--json" Option hinzu:

{{< example session_status_json >}}

Falls Sie nicht eingeloggt sind, erhalten sie eine informative Ausgabe und einen leeren TOML/JSON Output:

{{< example session_status_not_logged_in >}}

{{< example session_status_not_logged_in_json >}}

Falls Sie diesen Befehl verwenden möchten, um programmatisch zu prüfen, ob Sitzungsdaten gespeichert sind, verwenden Sie zum Beispiel den "raw" Ausgabemodus um den Info Trace zu vermeiden, und prüfen Sie, ob die Ausgabe leer ist:

{{< tabs >}}
{{% tab title="bash" %}}
``` bash
#!/bin/bash

output=$(bomnipotent_client --output-mode raw session status)
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
$output = bomnipotent_client --output-mode raw session status
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

{{< example session_logout >}}

Dies entfernt die Sitzungsdatei.
