+++
title = "CSAF Dokumente"
slug = "csaf-docs"
weight = 40
description = "Information on how to list and download CSAF documents using BOMnipotent, including command examples and output formats."
+++

Wenn eine Sicherheitslücke in einer der Komponenten eines von Ihnen genutzten Produkts bekannt wird, stellt sich eine der naheliegendsten Fragen: "Was muss ich jetzt tun?". Das [Common Security Advisory Format (CSAF)](https://www.csaf.io/) soll diese Frage auf automatisierte Weise beantworten. Es handelt sich um ein hauptsächlich maschinenlesbares Format zum Austausch von Sicherheitswarnungen zu Schwachstellen.

Eine der Hauptfunktionen von BOMnipotent besteht darin, die Verteilung von CSAF-Dokumenten so einfach wie möglich zu gestalten. Jede laufende Instanz des BOMnipotent-Servers fungiert als "CSAF Provider" gemäß dem [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider).

## Auflistung

Das Ausführen des Befehls

```
./bomnipotent_client csaf list
```

gibt eine Liste aller für Sie zugänglichen CSAF-Dokumente aus.

``` {wrap="false" title="output"}
╭───────────────┬───────────────────────────┬──────────────────────┬──────────────────────┬────────┬───────────╮
│ ID            │ Title                     │ Initial Release      │ Current Release      │ Status │ TLP       │
├───────────────┼───────────────────────────┼──────────────────────┼──────────────────────┼────────┼───────────┤
│ BSI-2022-0001 │ CVRF-CSAF-Converter: XML  │ 2022-03-17 13:03 UTC │ 2022-07-14 08:20 UTC │ final  │ TLP:WHITE │
│               │ External Entities Vulnera │                      │                      │        │           │
│               │ bility                    │                      │                      │        │           │
╰───────────────┴───────────────────────────┴──────────────────────┴──────────────────────┴────────┴───────────╯
```

Zugängliche CSAF-Dokumente sind diejenigen, die entweder mit {{<tlp-white>}}/{{<tlp-clear>}}, gekennzeichnet sind oder sich auf ein Produkt beziehen, für das Sie Zugriff erhalten haben.

## Herunterladen

Um alle für Sie zugänglichen CSAF-Dokumente lokal zu spiegeln, führen Sie den folgenden Befehl aus:
```
bomnipotent_client csaf download ./csaf
```
``` {wrap="false" title="output"}
[INFO] Storing CSAF documents under ./csaf
```

Dies speichert die CSAF-Dokumente im angegebenen Ordner ("./csaf"in diesem Beispiel). Falls der Ordner noch nicht existiert, wird die Verzeichnisstruktur automatisch erstellt. Die CSAF-Dokumente werden in Dateipfaden abgelegt, die dem Namensschema `{tlp}/{initial_release_year}/{csaf_id}.json`. 

> Die Dateinamen der CSAF-Dokumente folgen einem vom [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename) vorgegebenen Namensschema: Die IDs werden in Kleinbuchstaben umgewandelt, und die meisten Sonderzeichen werden durch einen Unterstrich '_' ersetzt. Das bedeutet, dass theoretisch verschiedene CSAF-Dokumente zum selben Dateipfad führen könnten. In einem solchen Fall zeigt BOMnipotent einen Fehler an, anstatt eine Datei stillschweigend zu überschreiben.


```
tree ./csaf/
```

``` {wrap="false" title="output"}
./csaf/
└── white
    └── 2022
        └── bsi-2022-0001.json
```

Bevor Dateien zum Download angefordert werden, erstellt der BOMnipotent-Client eine Inventarliste der bereits im Ordner vorhandenen CSAF-Dokumente und lädt nur die fehlenden herunter.

Es ist auch möglich, eine einzelne Datei herunterzuladen, indem der Pfad als zusätzliches Argument angegeben wird:

```
bomnipotent_client csaf download ./csaf white/2022/bsi-2022-0001.json
```

## Anzeigen

Sie können den Inhalt eines einzelnen CSAF Dokuments direkt in die Konsole ausgeben lassen, indem Sie folgendes rufen:
```bash
bomnipotent_client csaf get <ID>
```
``` {wrap="false" title="output (cropped)"}
{
  "document" : {
    "aggregate_severity" : {
      "text" : "mittel"
    },
    "category" : "csaf_base",
    "csaf_version" : "2.0",
    "distribution" : {
      "tlp" : {
        "label" : "WHITE",
...
```

Das ist besonder praktisch falls Sie den Inhalt des CSAF Dokuments in einem Skript weiterverwenden wollen.
