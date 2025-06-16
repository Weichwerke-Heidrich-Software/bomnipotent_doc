+++
title = "Log Datei"
slug = "log-file"
weight = 60
description = "Speichern Sie die Log-Ausgabe des BOMnipotent Clients in einer Datei, um Fehlermeldungen zu analysieren und die Datenverarbeitung zu optimieren."
+++

Um die Log Ausgabe eines BOMnipotent Client Aufrufs in einer Datei zu speichern anstatt sie auf stdout zu schreiben, rufen Sie:

{{< example log_file >}}

Die Ausgabe ist die Gleiche, abgesehen davon, dass sie für stdout entsprechend ihres Schweregrades eingefärbt wird, und für ide Logdatei nicht.

Falls BOMnipotent Client wiederholt mit derselben Logdatei gerufen wird, wird es diese **überschreiben**, **falls** die existierende Datei aussieht wie eine Logdatei.

> Eine Datei sieht für BOMnipotent wie eine Logdatei aus, falls sie entweder leer ist, oder mindestens einen der Strings "[ERROR]", "[WARN]", "[INFO]", "[DEBUG]" oder "[TRACE]" enthält.

Falls eine existierende Datei nicht wie eine Logdatei aussieht, wird BOMnipotent vorsichtigt und bricht ab:

{{< example log_file_abort >}}

Da die Befehle ["bom get"](/de/client/consumer/boms/#get) / ["csaf get"](/de/client/consumer/csaf-docs/#get) und "fetch" dafür gedacht sind, von Maschinen verarbeitet zu werden, schreiben sie ihre Ausgabe in stdout, **selbst wenn eine Logdatei konfiguriert ist**. Diese Trennung der Ausgaben macht es möglich, gleichzeitig die Daten zu verarbeiten und mögliche Fehlermeldungen zu speichern.
