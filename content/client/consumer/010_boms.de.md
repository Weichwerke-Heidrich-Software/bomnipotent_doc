+++
title = "Stücklisten / BOMs"
slug = "boms"
weight = 10
description = "Learn about BOMs (Bills of Materials), how to list accessible BOMs using bomnipotent_client, and download them locally, including file naming conventions."
+++


Stücklisten (Bills of Materials, BOMs) stehen im Mittelpunkt sowohl der Funktionalität als auch des Namens von BOMnipotent. Eine BOM ist eine Liste aller Komponenten, die ein Produkt ausmachen. Im Bereich der Cybersicherheit ist die bekannteste Variante die Software-Stückliste (Software Bill of Materials, SBOM), aber BOMs ermöglichen auch allgemeinere Überlegungen.

## Auflisten

Das Ausführen des folgenden Befehls listet alle für Sie zugänglichen BOMs auf:

{{< example bom_list >}}

BOMs mit der Klassifizierung {{<tlp-white>}} / {{<tlp-clear>}} sind für alle sichtbar. In diesem Beispiel hat Ihr Konto Zugriff auf eine BOM mit dem Label {{<tlp-amber>}}.

Der Befehlt akzeptiert die optionalen Filter "name" und "version":

{{< example bom_filtered_list >}}

## Herunterladen

Um eine lokale Kopie aller BOMs zu erstellen, die der Server für Sie bereitstellt, führen Sie folgenden Befehl aus:

{{< example bom_download >}}

Dies speichert die BOMs im angegebenen Ordner ("./boms" in diesem Beispiel). Falls der Ordner noch nicht existiert, wird er automatisch erstellt. Die BOMs werden in Dateien gespeichert, die folgendem Namensschema folgen: `{Produktname}_{Produktversion}.cdx.json`.

> Um inkonsistentes Verhalten zwischen verschiedenen Betriebssystemen zu vermeiden, werden der Name und die Version des Produkts in Kleinbuchstaben umgewandelt, und die meisten Sonderzeichen durch einen Unterstrich '_' ersetzt. Dadurch könnte es theoretisch vorkommen, dass verschiedene Produkte zum selben Dateinamen führen. In einem solchen Fall zeigt BOMnipotent eine Warnung an, anstatt die Datei stillschweigend zu überschreiben.

Der Client lädt auch mehrere Dateien herunter, die ein Hash und den Dateinamen der gehashten Datei enthalten.

{{< example tree_boms >}}

Bevor BOMnipotent Client Dateien zum Download anfordert, erstellt er eine Inventarliste der bereits im Ordner vorhandenen BOMs und lädt nur die fehlenden Dateien herunter.

BOMnipotent überschreibt existierende Dateien **nicht**, selbst falls sie sich auf dem Server geändert haben. Stattdessen gibt es eine Warnung aus:

{{< example bom_download_warn >}}

Sie können BOMnipotentn mitteilen, dass Sie die Datei wirklich gern überschrieben hätten, indem Sie die "--overwrite" flag nutzen:

{{< example bom_download_overwrite >}}

Analog zum [list](#auflisten) Befehl akzeptiert der download Befehl die Filter "name" und "version", sodass nur ein Teil der BOMs heruntergeladen wird:

{{< example bom_filtered_download >}}

## Anzeigen

Sie können den Inhalt einer einzelnen BOM direkt in die Konsole ausgeben lassen, indem Sie folgendes rufen:

{{< example bom_get >}}

Das ist besonder praktisch falls Sie den Inhalt der BOM in einem Skript weiterverwenden wollen. Falls sie zum Beispiel nach [Schwachstellen in der Lieferkette](/de/integration/grype/) schauen wollen, können sie folgendes rufen:

{{< example bom_get_grype >}}

## Existenz

{{< exist-subcommand-de >}}

{{< example bom_exist >}}
