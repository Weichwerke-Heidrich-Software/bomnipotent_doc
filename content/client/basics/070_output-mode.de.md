+++
title = "Ausgabemodus"
slug = "output-mode"
weight = 70
description = "Erfahren Sie, wie der BOMnipotent Client Lognachrichten ausgibt und die Ausgabemodi \"code\" und \"raw\" für Automatisierung und Skripte nutzt."
+++

Ohne das irgendein Ausgabemodus angegeben ist, schreibt BOMnipotent Client seine Lognachrichten entweder auf stdout, oder in eine konfigurierte [Logdatei](/de/client/basics/log-file/). Das ist großartig falls es von Menschen genutzt wird, aber nicht so praktisch für Automation. Deswegen bietet BOMnipotent Client zusätzlich die beiden Ausgabemodi ["code"](#code) und ["raw"](#raw) an. Diese modifizieren welche Ausgabe wohin geschrieben wird.

## Ausgaben

In den Ausgabemodi "code" oder "raw" wird nur der HTTP Code oder der Response Body zu stdout ausgegeben. Falls Sie [eine Logdatei konfiguriert haben](/de/client/basics/log-file/), werden alle Logs bis zu dem angegebenen [Log-Level](/de/client/basics/log-level/) dort gespeichert.

Falls Sie hingegen keine Logdatei angegeben haben, will BOMnipotent Sie dennoch wissen lassen, falls etwas schiefgeht. Deswegen werden in diesem Fall Lognachrichten mit den Schweregraden "error" oder "warn" zu stderr ausgegeben.

## Modi

## Code

Der code-Modus gibt nur den [HTTP Statuscode](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) der Antwort aus.

{{< example health_code >}}

Das ist besonders nützlich, wenn Sie BOMnipotent-Client in einem Skript verwendet möchten:
``` bash
#!/bin/bash
set -e # Return on error
# ...other code...
bomnipotent_client \
    --output-mode=code \
    --domain=$domain \
    --log-level=debug \
    --log-file="/tmp/loggy.log" \
    session login
code=$(bomnipotent_client health)
if (( code != 200 )); then
    echo "Server at $domain is not healthy!"
    cat /tmp/loggy.log
    exit 1;
fi
```

> Beachten Sie, dass am Ende der Ausgabe kein Zeilenumbruch oder Wagenrücklaufzeichen steht.

> "Wagenrücklaufzeichen" ist tatsächlich die deutsche Übersetzung von "carriage return". Abgefahren.

**Achtung:** Im Code Modus hat BOMnipotent Client immer einen Terminal Rückgabewert von 0 (was Erfolg anzeigt), *egal welchen* HTTP Code es zurückbekommt. Das macht es leichter, das Programm in Skripten zu verwenden, welche bei einem Fehler abbrechen.

## Raw

Für Aufrufe, die auf strukturierte Daten zugreifen, gibt der raw-Modus die Daten aus dem Response Body aus, welche üblicherweise im JSON Format vorliegen.

{{< example bom_list_raw >}}

Die Ausgabe kann dann einfach von der Programmlogik analysiert und weiterverarbeitet werden.

> Beachten Sie, dass am Ende der Ausgabe kein Zeilenumbruch oder Wagenrücklaufzeichen steht.
