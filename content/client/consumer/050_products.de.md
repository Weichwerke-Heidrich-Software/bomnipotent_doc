+++
title = "Produkte"
slug = "products"
weight = 50
description = "Produktliste eines CSAF Dokuments mit Befehlsanleitung und tabellarischer Ausgabe der Produkte, deren Schwachstellen, Status, CSAF ID und TLP."
+++

## Auflisten

Um genau zu sehen, welche Produkte von welchem CSAF Dokument behandelt werden, führen Sie den folgenden Befehl aus:

{{< example product_list >}}

Der Befehl akzeptiert die optionalen Filter "name", "vulnerability", "status" und "csaf":

{{< example product_filtered_list >}}

## Existenz

{{< exist-subcommand-de >}}

{{< example product_exist >}}

## Zuordnung

Um Herauszufinden, ob der Server BOM Dokumente hostet, welche Komponenten enthalten, die von lokal verfügbaren Advisories betroffen sind, können Sie den "csaf match" Befehl rufen und einen oder mehrere Pfade zu CSAF Dokumenten übergeben. BOMnipotent erfragt daraufhin alle BOM Dokumente vom Server und vergleicht deren Komponenten mit allen übergebenen CSAF Dokumenten:

{{< example "csaf_match" "1.2.0" >}}

## Analysieren

Das Ausführen des Befehls "product analyze" mit einem oder meheren Dateipfaden zu gültigen CSAF Dateien stellt die (kombinierten) Produkte tabellarisch dar, die von diesen Dokumenten behandelt werden:

{{< example "product_analyze" "1.2.0" >}}
