+++
title = "Komponenten"
slug = "bom-components"
weight = 20
description = "Katalogisiert die Komponenten eines Produkts mit BOMnipotent Client, und erklärt maschinenlesbare Optionen."
+++

## Auflisten

Der Zweck eines Stücklistenverzeichnisses (Bill of Materials, BOM) besteht darin, die Komponenten eines Produkts zu katalogisieren. BOMnipotent Client kann verwendet werden, um alle Pakete usw. aufzulisten, die in einem Produkt enthalten sind, welches über Ihr Benutzerkonto zugänglich ist. Rufen Sie einfach den Client mit den Argumenten "component", "list" und anschließend dem Namen und der Version des Produkts auf:

{{< example component_list >}}

Der Befehl akzeptiert die optionalen Filter "name", "version", "type", "cpe" und "purl" (der Kürze zuliebe hier nicht alle genutzt):

{{< example component_filtered_list >}}

Diese Ausgabe ist in erster Linie für den Menschen lesbar. Die Verwendung der Option `--output-mode=raw` macht sie prinzipiell maschinenlesbar, aber [das vollständige Herunterladen der BOM ](/de/client/consumer/boms/) ist höchstwahrscheinlich vorzuziehen, anstatt diese Tabellenausgabe zu parsen.

Ein Anbieter eines Produkts sollte die BOM eines Produkts regelmäßig auf Schwachstellen überprüfen, beispielsweise mit Tools wie [grype](/de/integration/grype/). Der [nächste Abschnitt](/de/client/consumer/vulnerabilities/) erklärt, wie Sie als Nutzer eines Produkts auf diese Listen zugreifen können.

## Analysieren

Das Ausführen des Befehls "component analyze" mit einem oder meheren Dateipfaden zu gültigen CycloneDX Dateien stellt die (kombinierten) Komponenten dieser BOMs tabellarisch dar:

{{< example "component_analyze" "1.2.0" >}}
