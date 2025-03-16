+++
title = "Stücklisten / BOMs"
slug = "boms"
weight = 10
description = "Learn about BOMs (Bills of Materials), how to list accessible BOMs using bomnipotent_client, and download them locally, including file naming conventions."
+++


Stücklisten (Bills of Materials, BOMs) stehen im Mittelpunkt sowohl der Funktionalität als auch des Namens von BOMnipotent. Eine BOM ist eine Liste aller Komponenten, die ein Produkt ausmachen. Im Bereich der Cybersicherheit ist die bekannteste Variante die Software-Stückliste (Software Bill of Materials, SBOM), aber BOMs ermöglichen auch allgemeinere Überlegungen.

## Auflistung

Das Ausführen des Befehls
```
bomnipotent_client bom list
```
listet alle für Sie zugänglichen BOMs auf:
``` {wrap="false" title="output"}
╭─────────────┬─────────┬─────────────────────────┬───────────┬────────────╮
│ Product     │ Version │ Timestamp               │ TLP       │ Components │
├─────────────┼─────────┼─────────────────────────┼───────────┼────────────┤
│ BOMnipotent │ 1.0.0   │ 2025-02-01 03:31:50 UTC │ TLP:WHITE │ 363        │
│ BOMnipotent │ 1.0.1   │ 2025-02-01 03:31:50 UTC │ TLP:WHITE │ 363        │
│ vulny       │ 0.1.0   │ 2025-02-02 06:51:40 UTC │ TLP:AMBER │ 63         │
╰─────────────┴─────────┴─────────────────────────┴───────────┴────────────╯
```

BOMs mit der Klassifizierung {{<tlp-white>}} / {{<tlp-clear>}} sind für alle sichtbar. In diesem Beispiel hat Ihr Konto Zugriff auf eine BOM mit dem Label {{<tlp-amber>}}.

## Herunterladen

Um eine lokale Kopie aller BOMs zu erstellen, die der Server für Sie bereitstellt, führen Sie folgenden Befehl aus:
```
bomnipotent_client bom download ./boms
```
``` {wrap="false" title="output"}
[INFO] Storing BOMs under ./boms
```

Dies speichert die BOMs im angegebenen Ordner ("./boms" in diesem Beispiel). Falls der Ordner noch nicht existiert, wird er automatisch erstellt. Die BOMs werden in Dateien gespeichert, die folgendem Namensschema folgen: `{Produktname}_{Produktversion}.cdx.json`.

> Um inkonsistentes Verhalten zwischen verschiedenen Betriebssystemen zu vermeiden, werden der Name und die Version des Produkts in Kleinbuchstaben umgewandelt, und die meisten Sonderzeichen durch einen Unterstrich '_' ersetzt. Dadurch könnte es theoretisch vorkommen, dass verschiedene Produkte zum selben Dateinamen führen. In einem solchen Fall zeigt BOMnipotent einen Fehler an, anstatt die Datei stillschweigend zu überschreiben.


```
tree ./boms/
```
``` {wrap="false" title="output"}
./boms/
├── bomnipotent_1.0.0.cdx.json
├── bomnipotent_1.0.1.cdx.json
└── vulny_0.1.0.cdx.json

1 directory, 3 files
```

Bevor BOMnipotent Client Dateien zum Download anfordert, erstellt er eine Inventarliste der bereits im Ordner vorhandenen BOMs und lädt nur die fehlenden Dateien herunter.

## Anzeigen

Sie können den Inhalt einer einzelnen BOM direkt in die Konsole ausgeben lassen, indem Sie folgendes rufen:
```bash
bomnipotent_client bom get <NAME> <VERSION>
```
``` {wrap="false" title="output (abgeschnitten)"}
{
  "$schema": "http://cyclonedx.org/schema/bom-1.6.schema.json",
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "serialNumber": "urn:uuid:60d5a033-6d54-4ac4-a5fa-824d0b04c718",
  "version": 1,
  "metadata": {
    "timestamp": "2025-02-23T07:23:33+01:00",
    "tools": {
      "components": [
...
```

Das ist besonder praktisch falls Sie den Inhalt der BOM in einem Skript weiterverwenden wollen. Falls sie zum Beispiel nach [Schwachstellen in der Lieferkette](/de/integration/grype/) schauen wollen, können sie folgendes rufen:
```bash
bomnipotent_client bom get <NAME> <VERSION> | grype
```
``` {wrap="false" title="output"}
NAME  INSTALLED  FIXED-IN  TYPE        VULNERABILITY        SEVERITY 
ring  0.17.10    0.17.12   rust-crate  GHSA-4p46-pwfr-66x6  Medium
```
