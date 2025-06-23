+++
title = "Log Level"
slug = "log-level"
weight = 50
description = "Erfahren Sie, wie Sie die verschiedenen Log-Level des BOMnipotent Clients nutzen, um Fehler zu identifizieren und die Ausgabe anzupassen."
+++

BOMnipotent Client bietet verschiedene Schweregrade an Logs:
- error
- warn
- info (default)
- debug
- trace

Diese können wie folgt ausgewählt werden:

{{< example log_level >}}

Sie definieren einen minimalen Schweregrad, den eine Nachricht haben muss um ausgegeben zu werden: Mit log-level debug gibt BOMnipotent alle Nachrichten der Schweregrade error, warn, info und debug aus, aber nicht trace.

Standardmäßig schreibt BOMnipotent Client die Nachrichten zu stdout, unabhängig vom Schweregrad. Sie können es stattdessen anweisen, die Logs [in eine Datei](/de/client/basics/log-file/) zu schreiben.

## Info, Warn und Error

Der Standard-Ausgabemodus ist info. Er gibt einige Informationen aus, überflutet den Benutzer jedoch nicht mit Nachrichten.

{{< example "health" >}}

{{< example "bom_list" >}}

## Debug

Der Debug-Ausgabemodus gibt zusätzliche Informationen aus, die bei der Fehlersuche in der Eingabe oder Konfiguration nützlich sein können:

{{< example health_debug >}}

## Trace

Im Trace-Modus gibt BOMnipotent alles aus, was es auch nur im Geringsten interessant findet. Dies ist primär nützlich, um Fehler *im Programm selbst* zu identifizieren.

{{< example health_trace >}}
