+++
title = "Komponentenliste"
slug = "bom-components"
weight = 20
description = "Katalogisiert die Komponenten eines Produkts mit BOMnipotent Client, zeigt die Nutzung und Ausgabe des Befehls bomnipotent_client component list und erklärt maschinenlesbare Optionen."
+++

Der Zweck eines Stücklistenverzeichnisses (Bill of Materials, BOM) besteht darin, die Komponenten eines Produkts zu katalogisieren. BOMnipotent Client kann verwendet werden, um alle Pakete usw. aufzulisten, die in einem Produkt enthalten sind, welches über Ihr Benutzerkonto zugänglich ist. Rufen Sie einfach den Client mit den Argumenten "component", "list" und anschließend dem Namen und der Version des Produkts auf:

```
bomnipotent_client component list vulny 0.1.0
```
``` {wrap="false" title="output"}
╭──────────────┬─────────┬─────────┬───────────────────────────┬───────────────────────────╮
│ Name         │ Version │ Type    │ CPE                       │ PURL                      │
├──────────────┼─────────┼─────────┼───────────────────────────┼───────────────────────────┤
│ aho-corasick │ 1.1.3   │ library │ cpe:2.3:a:aho-corasick:ah │ pkg:cargo/aho-corasick@1. │
│              │         │         │ o-corasick:1.1.3:*:*:*:*: │ 1.3                       │
│              │         │         │ *:*:*                     │                           │
│ aws-lc-rs    │ 1.12.2  │ library │ cpe:2.3:a:aws-lc-rs:aws-l │ pkg:cargo/aws-lc-rs@1.12. │
│              │         │         │ c-rs:1.12.2:*:*:*:*:*:*:* │ 2                         │
│ aws-lc-sys   │ 0.25.0  │ library │ cpe:2.3:a:aws-lc-sys:aws- │ pkg:cargo/aws-lc-sys@0.25 │
│              │         │         │ lc-sys:0.25.0:*:*:*:*:*:* │ .0                        │
│              │         │         │ :*                        │                           │
│ bindgen      │ 0.69.5  │ library │ cpe:2.3:a:bindgen:bindgen │ pkg:cargo/bindgen@0.69.5  │
│              │         │         │ :0.69.5:*:*:*:*:*:*:*     │                           │

...
```

Diese Ausgabe ist in erster Linie für den Menschen lesbar. Die Verwendung der Option `--output=raw` macht sie prinzipiell maschinenlesbar, aber [das vollständige Herunterladen der BOM ](/de/client/consumer/boms/) ist höchstwahrscheinlich vorzuziehen, anstatt diese Tabellenausgabe zu parsen.

Ein Anbieter eines Produkts sollte die BOM eines Produkts regelmäßig auf Schwachstellen überprüfen, beispielsweise mit Tools wie [grype](/de/integration/grype/). Der [nächste Abschnitt](/de/client/consumer/vulnerabilities/) erklärt, wie Sie als Nutzer eines Produkts auf diese Listen zugreifen können.
