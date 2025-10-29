+++
title = "Sicherheitslücken"
slug = "vulnerabilities"
weight = 30
description = "Anleitung zur Anzeige bekannter Sicherheitslücken eines Produkts mit Beispielausgabe und Erklärung der enthaltenen Informationen wie CVSS-Wert und TLP-Klassifizierung."
+++

## Auflisten

Um eine Liste bekannter, Ihnen zugänglicher Sicherheitslücken anzuzeigen, rufen Sie:

{{< example vuln_list >}}

Die Ausgabe enthält eine ID für die Sicherheitslücke, eine Beschreibung sowie, und, falls verfügbar, einen  [CVSS Wert](https://www.first.org/cvss/) und/oder eine Schweregrad-Einstufung. Zudem enthält sie eine [TLP Klassifizierung](https://www.first.org/tlp/), welche sich von der des betroffenen Produkts ableitet, und idealerweise eine [CSAF Bewertung](https://www.csaf.io/) durch den Anbieter.

Die Liste kann nach Name und/oder Version des betroffenen Produkts gefiltert werden:

{{< example vuln_filtered_list >}}

Um nur diejenigen Sicherheitslücken anzuzeigen, welche noch nicht durch ein CSAF Advisory abgedeckt sind, rufen Sie:

{{< example vuln_list_unassessed >}}

Das Verhalten ist hier besonders: Falls es unbehandelte Sicherheitslücken gibt, gibt der Client einen Fehlercode zurück. Das dient dazu, die Integration mit Skripten zu erleichtern, welche regelmäßig auf neue Sicherheitslücken prüfen, wie es zum Beispiel im [Abschnitt über CI/CD](/de/integration/ci-cd/) beschrieben ist.

Es ist auch möglich, lediglich die Sicherheitslücken aufzulisten, welche bereits mit einem Advisory verknüpft sind, allerdings legt der Client hier kein besonderes Verhalten an den Tag:

{{< example vuln_list_unassessed_false >}}

Das CSAF-Dokument ist ein entscheidender Bestandteil, da es Ihnen als Nutzer des Produkts mitteilt, wie Sie auf diese Sicherheitslücke in der Lieferkette reagieren sollten. Lesen Sie den [nächsten Abschnitt](/de/client/consumer/csaf-docs/), um herauszufinden, wie Sie darauf zugreifen können.

## Existenz

{{< exist-subcommand-de >}}

{{< example vuln_exist >}}

## Analysieren

Das Ausführen des Befehls "vulnerability analyze" mit einem oder meheren Dateipfaden zu gültigen CycloneDX Dateien stellt die (kombinierten) Sicherheitslücken dieser BOMs tabellarisch dar:

{{< example "vuln_analyze" "1.2.0" >}}
