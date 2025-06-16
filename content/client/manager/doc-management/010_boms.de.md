+++
title = "BOMs"
slug = "boms"
weight = 10
description = "Erfahren Sie, wie Sie Stücklisten (BOMs) in BOMnipotent hochladen, ändern und löschen."
+++

Stücklisten (Bills of Materials, BOMs) stehen im Mittelpunkt der Funktionalität und des Namens von BOMnipotents. Eine BOM ist eine Liste aller Komponenten, aus denen ein Produkt besteht. Im Kontext der Cybersicherheit ist die Software-BOM (SBOM) die bekannteste Variante, BOMs ermöglichen aber auch allgemeinere Überlegungen.

> Für BOM-Interaktionen, die über das Lesen hinausgehen, benötigen Sie die Berechtigung {{<bom-management-de>}}. Im Abschnitt zur [Verwaltung von Zugriffsrechten](/de/client/manager/access-management/) wird beschrieben, wie diese erteilt wird.

## Hochladen

Um eine BOM hochzuladen, rufen Sie Folgendes auf:

{{< example bom_upload >}}

BOMnipotent erwartet seine BOM im strukturierten [CycloneDX](https://cyclonedx.org/) JSON-Format.

> Im [Syft-Tutorial](/de/integration/syft) erfahren Sie, wie Sie eine BOM für Ihr Produkt erstellen.

Der BOMnipotent Client ließt die Datei unter dem angegebenen Pfad und lädt ihren Inhalt hoch. Die BOM kann dann von Konsumenten mit entsprechenden Berechtigungen eingesehen werden.

> [BOMs für Konsumenten](/de/client/consumer/boms/) beschreibt, wie die BOMs auf dem Server aufgelistet und heruntergeladen werden.

Um eine BOM zur Datenbank hinzuzufügen, benötigt der BOMnipotent Client einige zusätzliche Informationen: einen Namen, eine Version und optional ein TLP-Label. Name und Version können entweder abgeleitet (empfohlen) oder wie unten beschrieben überschrieben werden.

### Name und Version

#### Ableitung (empfohlen)

BOMnipotent verwendet Name und Version zur Identifizierung einer Stückliste. Diese werden aus den bereitgestellten CycloneDX-JSON-Feldern "metadata.component.name" und "metadata.component.version" abgeleitet. Gemäß der [CycloneDX-Spezifikation](https://cyclonedx.org/docs/1.6/json/#metadata_component) ist das Feld "metadata.component" jedoch optional.

Wenn keine Version angegeben ist, verwendet BOMnipotent stattdessen das Datum von "metadata.timestamp", sofern verfügbar.

Um Komplikationen zu vermeiden, wird empfohlen, beim Generieren der Stückliste Name und Version anzugeben, wie im [Syft-Tutorial](/de/integration/syft) beschrieben.

#### Überschreiben (nicht besonders empfohlen)

Falls Ihrer BOM aus irgendeinem Grund ein Name oder eine Version fehlt oder diese fehlerhaft ist, bietet der BOMnipotent Client die Möglichkeit, dies über Befehlszeilenargumente zu beheben:

{{< example bom_upload_overwrite >}}

**Wichtig:** Der BOMnipotent Client **ändert in diesem Fall die Daten**, bevor sie an den Server gesendet werden. Die lokale Datei wird nicht geändert, da dies zu weit gehen würde. Das bedeutet, dass Ihre lokale Datei und die Daten auf dem Server nicht mehr synchron sind. Schlimmer noch: Falls Sie Ihre BOM signiert haben, ist Ihre Signatur nun ungültig.

Falls Sie diese Option nutzen, wird daher empfehlen, die BOM umgehend vom Server herunterzuladen (wie in [BOMs für Verbraucher](/de/client/consumer/boms/) beschrieben) und Ihre lokale Datei durch das Ergebnis zu ersetzen.

### TLP-Klassifizierung

Für Konsumenten verwaltet BOMnipotent den Datenzugriff über das [Traffic Light Protocol (TLP)](https://www.first.org/tlp/). Das
[CycloneDX-Format](https://cyclonedx.org/) unterstützt derzeit keine Dokumentklassifizierung.

Um BOMnipotent mitzuteilen, wie ein Dokument klassifiziert werden soll, haben Sie zwei Möglichkeiten:
1. Legen Sie in der Serverkonfiguration ein [Default-TLP-Label](/de/server/configuration/optional/tlp-config/) fest. Dieses wird dann für alle BOMs ohne weitere Spezifikationen verwendet.
2. Geben Sie eine TLP-Klassifizierung per Kommandozeilenargument an:

{{< example bom_upload_tlp >}}

Falls Sie keines von beiden tun, behandelt BOMnipotent alle nicht klassifizierten Dokumente so, als wären sie mit dem Label {{< tlp-red >}} gekennzeichnet, und gibt jedes Mal eine Warnung aus, wenn dies erforderlich ist.

### Konfliktbehandlung

Die Kombination aus Name und Version der Hauptkomponente einer BOM muss eindeutig sein. Der Versuch, ein weiteres Dokuement mit derselben Kombination hochzuladen, resultiert in einem Fehler. Sie können dieses Verhalten mit der "on-existing" Option überschreiben, und BOMnipotent anweisen, Dokumente im Konfliktfall entweder zu überspringen oder zu ersetzen:

{{< example bom_upload_skip_existing >}}

{{< example bom_upload_replace_existing >}}

## Ändern

Im einfachsten Fall funktioniert das Ändern einer vorhandenen Stückliste ähnlich wie das Hochladen einer neuen.

{{< example bom_modify >}}

Dadurch werden Name und Version des Dokuments abgeleitet und der vorhandene Inhalt auf dem Server überschrieben. Sollten die Daten auf dem Server nicht vorhanden sein, wird ein 404-Fehler "Nicht gefunden" zurückgegeben.

### TLP-Label ändern

Wenn der Stückliste zuvor ein TLP-Label zugewiesen wurde, wird dieses durch eine Änderung des Inhalts **nicht** automatisch geändert.

Wenn Sie ein neues TLP-Label angeben möchten, können Sie dies über das folgende Argument tun:

{{< example bom_modify_tlp>}}

Wenn sich der Inhalt der Stückliste nicht geändert hat und Sie nur das TLP-Label ändern möchten, müssen Sie das Dokument nicht erneut hochladen. Anstatt einen Dateipfad anzugeben, können Sie Name und Version der neu zu klassifizierenden BOM angeben:

{{< example bom_modify_only_tlp >}}

Wenn Sie als TLP-Label "none", "default" oder "unlabelled" angeben, wird jede vorhandene Klassifizierung entfernt und der Server greift auf das [Default-TLP-Label](/de/server/configuration/optional/tlp-config/) der Serverkonfiguration zurück:

{{< example bom_modify_remove_tlp >}}

### Name oder Version ändern

Wenn das hochgeladene Dokument einen anderen Namen oder eine andere Version hat als die zu ändernden Daten, müssen Sie diese Informationen dem BOMnipotent-Client mithilfe der folgenden Befehlszeilenargumente mitteilen:

{{< example bom_modify_name >}}

BOMnipotent leitet die neuen Daten aus dem von Ihnen bereitgestellten Dokument ab und ändert die Datenbankeinträge entsprechend.

### Name oder Version überschreiben (nicht empfohlen)

Wie beim Hochladen können Sie den im lokalen Dokument gespeicherten Namen und/oder die Version überschreiben:

{{< example bom_modify_overwrite_name >}}

**Wichtig:** Wie beim Hochladen werden die JSON-Daten vor dem Hochladen auf den Server geändert! Es gelten die gleichen Dinge zu bedenken.

Wenn die Daten auf dem Server einen anderen Namen und/oder eine andere Version haben als im Dokument angegeben, können Sie die Angabe mit einem Überschreiben der Daten kombinieren:

{{< example bom_modify_overwrite_name_extreme >}}

Das Ändern von Name und/oder Version ohne Angabe des vollständigen Dokuments ist nicht unterstützt.

## Löschen

Das Löschen einer BOM ist sehr einfach:

{{< example bom_delete >}}

Falls die BOM nicht existiert, gibt der Server den Fehler 404 "Nicht gefunden" zurück. Ist sie vorhanden, wird sie aus der Datenbank entfernt.

Alle Komponenten und Sicherheitslücken, die mit der BOM assoziiert sind, werden ebenfalls gelöscht.
