+++
title = "CSAF Dokumente"
slug = "csaf-docs"
weight = 30
description = "Anleitung zur Verwaltung von CSAF-Dokumenten: Hochladen, Ändern und Löschen von Sicherheitsberichten gemäß OASIS CSAF-Standard."
+++

Ein [Common Security Advisory Framework](https://www.csaf.io/) (CSAF)-Dokument ist die Antwort eines Herstellers auf eine neu entdeckte Sicherheitslücke. Es ist ein maschinenlesbares Format, welches Informationen darüber verbreitet, wie Nutzer Ihres Produkts reagieren sollten: Muss auf eine neuere Version aktualisiert werden? Muss eine Konfiguration geändert werden? Ist Ihr Produkt überhaupt betroffen oder ruft es den betroffenen Teil der anfälligen Bibliothek möglicherweise nie auf?

> Für CSAF-Interaktionen, die über das Lesen hinausgehen, benötigen Sie die Berechtigung {{<csaf-management-de>}}. Im Abschnitt über die [Verwaltung von Zugriffsrechten](/de/client/manager/access-management/) wird beschrieben, wie diese erteilt wird.

## Hochladen

Um ein CSAF-Dokument hochzuladen, rufen Sie

{{< example csaf_upload >}}

Bevor Ihr CSAF-Dokument hochgeladen wird, prüft der BOMnipotent Client, ob es gemäß dem [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests) gültig ist.

### Konfliktbehandlung

CSAF Dokumente werden durch ihren, nun ja, Identifikator identifiziert, welcher eindeutig sein muss. Der Versuch, ein weiteres Dokuement mit derselben ID hochzuladen, resultiert in einem Fehler:

{{< example csaf_upload_err_on_existing >}}

Sie können dieses Verhalten mit der "on-existing" Option überschreiben, und BOMnipotent anweisen, Dokumente im Konfliktfall entweder zu überspringen oder zu ersetzen:

{{< example csaf_upload_skip_existing >}}

{{< example csaf_upload_replace_existing >}}

## Auflisten

Sie können das Ergebnis des Vorgangs mit

{{< example csaf_list >}}

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

{{< example csaf_modify >}}

Der Befehl kann sogar die ID vom CSAF Dokument modifizieren. Da die bisheriger ID in diesem Fall nicht aus dem neuen Dokument abgeleitet werden kann, muss sie als optionales Argument angegeben werden:

{{< example csaf_modify_id >}}

## Löschen

Um ein CSAF-Dokument von Ihrem Server zu löschen (was Sie wirklich nur tun sollten, falls etwas komplett schiefgelaufen ist), rufen Sie einfach Folgendes auf:

{{< example csaf_delete >}}
