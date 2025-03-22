+++
title = "CSAF Dokumente"
slug = "csaf-docs"
weight = 30
description = "Anleitung zur Verwaltung von CSAF-Dokumenten: Hochladen, Ändern und Löschen von Sicherheitsberichten gemäß OASIS CSAF-Standard."
+++

Ein Common Security Advisory Format (CSAF)-Dokument ist die Antwort eines Herstellers auf eine neu entdeckte Sicherheitslücke. Es ist ein maschinenlesbares Format, welches Informationen darüber verbreitet, wie Nutzer Ihres Produkts reagieren sollten: Muss auf eine neuere Version aktualisiert werden? Muss eine Konfiguration geändert werden? Ist Ihr Produkt überhaupt betroffen oder ruft es den betroffenen Teil der anfälligen Bibliothek möglicherweise nie auf?

> Für CSAF-Interaktionen, die über das Lesen hinausgehen, benötigen Sie die Berechtigung {{<csaf-management-de>}}. Im Abschnitt über die [Verwaltung von Zugriffsrechten](/de/client/manager/access-management/) wird beschrieben, wie diese erteilt wird.

## Hochladen

Um ein CSAF-Dokument hochzuladen, rufen Sie
```
bomnipotent_client csaf upload <PFAD/ZUM/CSAF> auf.
```

``` {wrap="false" title="Ausgabe"}
[INFO] Uploaded CSAF with id WID-SEC-W-2024-3470
```

Bevor Ihr CSAF-Dokument hochgeladen wird, prüft der BOMnipotent Client, ob es gemäß dem [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests) gültig ist.

Sie können das Ergebnis des Vorgangs mit
```
bomnipotent_client csaf list
```
``` {wrap="false" title="Ausgabe"}
╭─────────────────────┬───────────────────────────┬─────────────────────────┬─────────────────────────┬────────┬───────────╮
│ ID                  │ Title                     │ Initial Release         │ Current Release         │ Status │ TLP       │
├─────────────────────┼───────────────────────────┼─────────────────────────┼─────────────────────────┼────────┼───────────┤
│ WID-SEC-W-2024-3470 │ binutils: Schwachstelle e │ 2024-11-14 23:00:00 UTC │ 2024-11-17 23:00:00 UTC │ final  │ TLP:WHITE │
│                     │ rmöglicht Denial of Servi │                         │                         │        │           │
│                     │ ce                        │                         │                         │        │           │
╰─────────────────────┴───────────────────────────┴─────────────────────────┴─────────────────────────┴────────┴───────────╯
```

Alle Daten stammen aus dem CSAF-Dokument.

Falls das Dokument nicht den optionalen TLP-Labeleintrag enthält, wird es mit dem für den Server konfigurierten [Default-TLP](/de/server/configuration/optional/tlp-config/) behandelt.


``` {wrap="false" title="Ausgabe"}
...┬────────┬─────────╮
...│ Status │ TLP     │
...┼────────┼─────────┤
...│ final  │ Default │
...┴────────┴─────────╯
```

## Ändern

Wenn sich der Status Ihres Dokuments ändert, Sie es neu klassifizieren möchten oder neue Informationen vorliegen, können Sie es ändern. Um die neue Version hochzuladen, rufen Sie Folgendes auf:

```
bomnipotent_client csaf delete <CSAF-ID> <PFAD/ZUM/CSAF>
```
``` {wrap="false" title="Ausgabe"}
[INFO] Modified CSAF with id BSI-2024-0001-unlabeled
```

Der Befehl benötigt die ID des gehosteten CSAF-Dokuments, da er diese im Prinzip ebenfalls ändern kann. Das neue CSAF-Dokument gilt als autorativ.

## Löschen

Um ein CSAF-Dokument von Ihrem Server zu löschen (was Sie wirklich nur tun sollten, falls etwas komplett schiefgelaufen ist), rufen Sie einfach Folgendes auf:
```
bomnipotent_client csaf delete <CSAF-ID>
```
``` {wrap="false" title="Ausgabe"}
[INFO] Deleted CSAF with id WID-SEC-W-2024-3470
```
