+++
title = "CSAF Dokumente"
slug = "csaf-docs"
weight = 40
description = "Information on how to list and download CSAF documents using BOMnipotent, including command examples and output formats."
+++

Wenn eine Sicherheitslücke in einer der Komponenten eines von Ihnen genutzten Produkts bekannt wird, stellt sich eine der naheliegendsten Fragen: "Was muss ich jetzt tun?". Das [Common Security Advisory Framework (CSAF)](https://www.csaf.io/) soll diese Frage auf automatisierte Weise beantworten. Es handelt sich um ein hauptsächlich maschinenlesbares Format zum Austausch von Sicherheitswarnungen zu Schwachstellen.

Eine der Hauptfunktionen von BOMnipotent besteht darin, die Verteilung von CSAF-Dokumenten so einfach wie möglich zu gestalten. Jede laufende Instanz des BOMnipotent-Servers fungiert als "CSAF Provider" gemäß dem [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider).

## Auflisten

Das Ausführen des folgenden Befehls gibt eine Liste aller für Sie zugänglichen CSAF-Dokumente aus:

{{< example csaf_list >}}

Zugängliche CSAF-Dokumente sind diejenigen, die entweder mit {{<tlp-white>}}/{{<tlp-clear>}}, gekennzeichnet sind oder sich auf ein Produkt beziehen, für das Sie Zugriff erhalten haben.

### Filtern

Der "csaf list" Befehl erlaubt eine große Anzahl an Filtern, um nur manche der CSAF Dokuemente anzuzeigen:
- *id*: Die ID eines CSAF Dokuments ist eindeutig, sodass dieser Filter höchstens ein Ergebnis liefern kann.
- *filename*: Laut dem [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename) erlauben CSAF IDs mehr Zeichen als deren Dateinamen. Aus diesem Grund ist der Dateiname eines CSAF Dokuments nicht zwingend eindeutig.
- *before*: Zeigt nur CSAF Dokumente, deren initiales Veröffentlichungsdatum vor einem bestimmten Zeitpunkt liegen. Die Eingabe kann in den Formaten "YYYY", "YYYY-MM", "YYYY-MM-DD", "YYYY-MM-DD HH", "YYYY-MM-DD HH:MM" oder "YYYY-MM-DD HH:MM:SS" erfolgen. Falls die Eingabe weniger als auf die Sekunde genau ist, wird der *niedrigste* Wert angenommen. Dies bedeutet, dass "before 2025-08" nach Dokumenten filtert, die vor 2025-08-01 00:00:00 veröffentlicht wurden. Als Zeitzohne wird UTC angenommen, es sei denn sie spezifizieren eine andere, indem Sie einen Offset (z.B. "+02:00") an den Input anfügen.
- *after*: Zeigt nur CSAF Dokumente, deren initiales Veröffentlichungsdatum hinter einem bestimmten Zeitpunkt liegen. Falls die Eingabe weniger als auf die Sekunde genau ist, wie der *höchste* Wert angenommen. Dies bedeutet, dass "after 2025-08" nach Dokumenten filtert, die nach 2025-08-31 13:59:59 veröffentlicht wurden.
- *year*: Zeigt nur CSAF Dokuemente, dere initiales Veröffentlichungsdatum in einem gegebenen Jahr liegen.
- *status*: Filtert nach Dokumentenstatus. Der [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#321127-document-property---tracking---status) listet alle erlaubten Werte.
- *tlp*: Zeigt nur CSAF Dokumente mit einer gewissen [TLP](https://www.first.org/tlp/) Klassifizierung. Zusätzlich zu den TLP1 und TLP2 Labeln sind auch "default", "none", "unclassified" und "unlabeled" hier valide Eingaben (welche alle dasselbe meinen).

{{< example csaf_filtered_list >}}

{{< example csaf_filtered_list_time_precision >}}

## Herunterladen

Um alle für Sie zugänglichen CSAF-Dokumente lokal zu spiegeln, führen Sie den folgenden Befehl aus:

{{< example csaf_download >}}

Dies speichert die CSAF-Dokumente im angegebenen Ordner ("/home/csaf"in diesem Beispiel). Falls der Ordner noch nicht existiert, wird die Verzeichnisstruktur automatisch erstellt. Die CSAF-Dokumente werden in Dateipfaden abgelegt, die dem Namensschema "{tlp}/{initial_release_year}/{csaf_id}.json".

Beginnend mit Version 1.3.0 kann hierfür ein beliebiger Server angegeben werden, welcher als [CSAF Provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider) agiert.

> Die Dateinamen der CSAF-Dokumente folgen einem vom [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename) vorgegebenen Namensschema: Die IDs werden in Kleinbuchstaben umgewandelt, und die meisten Sonderzeichen werden durch einen Unterstrich '_' ersetzt. Das bedeutet, dass theoretisch verschiedene CSAF-Dokumente zum selben Dateipfad führen könnten. In einem solchen Fall zeigt BOMnipotent einen Fehler an, anstatt eine Datei stillschweigend zu überschreiben.

Der Client lädt auch mehrere Dateien herunter, die ein Hash und den Dateinamen der gehashten Datei enthalten.

Falls [OpenPGP](/de/server/configuration/optional/open-pgp/) auf dem Server konfiguriert ist, lädt der Client weiterhin kryptografische Signaturen für die CSAF Dokumente herunter. Diese werden in ".json.asc" Dateien gespeichert, und können zum Beispiel mit [Sequoia-PGP](/de/integration/open-pgp/) verifiziert werden.

{{< example tree_csaf >}}

Bevor Dateien zum Download angefordert werden, erstellt der BOMnipotent-Client eine Inventarliste der bereits im Ordner vorhandenen CSAF-Dokumente und lädt nur die fehlenden herunter.

Es ist auch möglich, eine einzelne Datei herunterzuladen, indem der Pfad als zusätzliches Argument angegeben wird:

{{< example csaf_download_single >}}

BOMnipotent überschreibt existierende Dateien **nicht**, selbst falls sie sich auf dem Server geändert haben. Stattdessen gibt es eine Warnung aus:

{{< example csaf_download_warn >}}

Sie können BOMnipotentn mitteilen, dass Sie die Datei wirklich gern überschrieben hätten, indem Sie die "overwrite" flag nutzen:

{{< example csaf_download_overwrite >}}

Der Download Befehl akzeptiert exakt die [gleichen Filter](#filtern) wie der Befehl zum Auflisten, sodass Sie nur die Dokumente herunterladen können, welche relevant für Sie sind.

## Anzeigen

Sie können den Inhalt eines einzelnen CSAF Dokuments direkt in die Konsole ausgeben lassen, indem Sie folgendes rufen:

{{< example csaf_get >}}

Das ist besonder praktisch falls Sie den Inhalt des CSAF Dokuments in einem Skript weiterverwenden wollen.

## Existenz

{{< exist-subcommand-de >}}

{{< example csaf_exist >}}

## Zuordnen

Um Herauszufinden, ob der Server BOM Dokumente hostet, welche Komponenten enthalten, die von lokal verfügbaren Advisories betroffen sind, können Sie den "csaf match" Befehl ausführen und einen oder mehr Pfade zu CSAF Dokumenten übergeben. BOMnipotent erfragt daraufhin alle BOM Dokumente vom Server und vergleicht deren Komponenten mit allen übergebenen CSAF Dokumenten:

{{< example "csaf_match" "1.2.0" >}}

## Analysieren

Das Ausführen des Befehls "csaf analyze" mit einem oder meheren Dateipfaden zu gültigen CSAF Dateien stellt die Metadaten dieser Dokumente tabellarisch dar:

{{< example "csaf_analyze" "1.2.0" >}}

Der Befehl führt eine komplette [Validitätsprüfung](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests) der CSAF Dokumente durch und kann somit unter anderem genutzt werden, um Abweichungen vom Standard zu entdecken:

{{< example "csaf_analyze_invalid" "1.2.0" >}}
