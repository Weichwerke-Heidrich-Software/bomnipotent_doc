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

Falls [OpenPGP](/de/server/configuration/optional/open-pgp/) auf dem Server konfiguriert ist, lädt der Client weiterhin kryptografische Signaturen für die BOMs herunter. Diese werden in ".json.asc" Dateien gespeichert, und können zum Beispiel mit [Sequoia-PGP](/de/integration/open-pgp/) verifiziert werden.

{{< example tree_boms >}}

Bevor BOMnipotent Client Dateien zum Download anfordert, erstellt er eine Inventarliste der bereits im Ordner vorhandenen BOMs und lädt nur die fehlenden Dateien herunter.

BOMnipotent überschreibt existierende Dateien **nicht**, selbst falls sie sich auf dem Server geändert haben. Stattdessen gibt es eine Warnung aus:

{{< example bom_download_warn >}}

Sie können BOMnipotentn mitteilen, dass Sie die Datei wirklich gern überschrieben hätten, indem Sie die "overwrite" flag nutzen:

{{< example bom_download_overwrite >}}

Analog zum [list](#auflisten) Befehl akzeptiert der download Befehl die Filter "name" und "version", sodass nur ein Teil der BOMs heruntergeladen wird:

{{< example bom_filtered_download >}}

## Anzeigen

Sie können den Inhalt einer einzelnen BOM direkt in die Konsole ausgeben lassen, indem Sie folgendes rufen:

{{< example bom_get >}}

Das ist besonder praktisch falls Sie den Inhalt der BOM in einem Skript weiterverwenden wollen. Falls sie zum Beispiel nach [Schwachstellen in der Lieferkette](/de/integration/grype/) schauen wollen, können sie folgendes ausführen:

{{< example bom_get_grype >}}

## Existenz

{{< exist-subcommand-de >}}

{{< example bom_exist >}}

## Zuordnen

Um Herauszufinden, ob der Server CSAF Dokumente hostet, welche Komponenten in Ihren Assets betreffen, können Sie den "bom match" Befehl ausführen und einen oder mehr Pfade zu BOM Dokumenten übergeben. BOMnipotent erfragt daraufhin alle CSAF Dokumente vom Server und vergleicht diese mit allen Komponenten in allen übergebenen BOMs:

{{< example "bom_match" "1.2.0" >}}

Beginnend mit Version 1.3.0 kann hierfür ein beliebiger Server angegeben werden, welcher als [CSAF Provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider) agiert.

{{< example "bom_match_other" "1.3.0" >}}

Der CSAF Standard macht mehrere Vorschläge, wo die Provider Metadata gehostet werden sollte, und wie sie gefunden werden kann. Manche Provider haben sich dennoch entschieden, sie an einer andereren Stelle zu hosten. Um auch mit diesen die Interoperabilität zu ermöglichen, kann die Provider Metadata URL explizit als Argument angegeben werden:

{{< example "bom_match_metadata" "1.4.0" >}}

Damit werden jegliche weitere Suchen überschrieben, und das "--domain" Argument somit effektiv ignoriert.

## Analysieren

Das Ausführen des Befehls "bom analyze" mit einem oder meheren Dateipfaden zu gültigen CycloneDX Dateien stellt die Metadaten dieser BOMs tabellarisch dar:

{{< example "bom_analyze" "1.2.0" >}}
