+++
title = "Sicherheitslücken"
slug = "vulnerabilities"
weight = 20
description = "Erfahren Sie, wie Sie Sicherheitslücken in Ihrer Lieferkette mit BOMnipotent und Tools wie grype erkennen, aktualisieren und auflisten können."
+++

Ein zentraler Bestandteil der Lieferkettensicherheit ist der Abgleich des Inhalts einer Stückliste (BOM), also aller Komponenten eines Produkts, mit Datenbanken bekannter Schwachstellen.

> Für Schwachstelleninteraktionen, die über das Lesen hinausgehen, benötigen Sie die Berechtigung {{<vuln-management-de>}}. Im Abschnitt zur [Verwaltung von Zugriffsrechten](/de/client/manager/access-management/) wird beschrieben, wie diese erteilt wird.

## Erkennen

BOMnipotent erkennt selbst keine neuen Schwachstellen. Ein Tool, das in Kombination mit BOMnipotent verwendet werden kann, ist [grype](https://github.com/anchore/grype). Es verwendet eine BOM als Eingabe und erstellt eine Liste der Schwachstellen als Ausgabe. Das [grype-Tutorial](/de/integration/grype/) enthält weitere Informationen zur Verwendung. Es können aber auch andere Tools verwendet werden, solange sie Output im [CycloneDX JSON Format](https://cyclonedx.org/) erstellen können.

Mit dem BOMnipotent-Client können Sie den Inhalt einer BOM direkt ausgeben und an grype weiterleiten.

{{< example bom_get_grype_output >}}

Dadurch werden die Softwarekomponenten anhand mehrerer Datenbanken geprüft und die Ergebnisse in das CycloneDX eingepflegt. Anschließend werden alle Ergebnisse in einer Datei namens "vuln.cdx.json" (oder einem anderen von Ihnen angegebenen Namen) gespeichert.

> Grype hat derzeit einen kleinen [bekannten Fehler](https://github.com/anchore/grype/issues/2418), der dazu führt, dass die Version der Hauptkomponente beim Hinzufügen der Schwachstellen vergessen wird. Dies ist problematisch, da BOMnipotent die Version zur eindeutigen Identifizierung eines Produkts benötigt. Eine mögliche Problemumgehung besteht darin, die Version erneut zum Dokument hinzuzufügen, beispielsweise über `jq '.metadata.component.version = "<VERSION>"' "vuln.cdx.json" > "vuln_with_version.cdx.json"`. Ab BOMnipotent v0.3.1 können Sie die Version stattdessen direkt beim Hochladen der Schwachstelle angeben, wie unten beschrieben.

## Aktualisierung

Der Befehl zum Aktualisieren der mit einer BOM verknüpften Schwachstellen lautet:

{{< example vuln_update >}}

Das Argument "\<VULNERABILITIES\>" muss ein Pfad zu einer Datei im [CycloneDX JSON-Format](https://cyclonedx.org/) sein.

Idealerweise enthält diese Datei den Namen und die Version der zugehörigen BOM. In diesem Fall werden diese automatisch gelesen. Falls einer der Werte fehlt (z. B. aufgrund eines [bekannten Fehlers](https://github.com/anchore/grype/issues/2418) in grype), können Sie ihn mit einem optionalen Argument angeben:

{{< example vuln_update_name_version >}}

Schwachstellen sollten regelmäßig aktualisiert werden. Dadurch werden alle vorherigen Schwachstellen, die mit einer BOM verknüpft sind, vollständig ersetzt. Das hochgeladene CycloneDX-Dokument muss daher eine vollständige Liste aller bekannten Schwachstellen enthalten.

Sie können Schwachstellen nur für eine BOM aktualisieren, die auf dem Server vorhanden ist:

{{< example vuln_update_nonexistent >}}

## Auflistung

Der Abschnitt zum [Auflisten von Schwachstellen](/de/client/consumer/vulnerabilities/) in der Dokumentation für Verbraucher behandelt die meisten Aspekte der Auflistung von Schwachstellen.

Ein Aspekt, der dort nicht erwähnt wird, ist die Option "--unassessed". Damit listet der BOMnipotent-Client nur Schwachstellen auf, denen kein CSAF-Dokument zugeordnet ist.

{{< example vuln_list_unassessed >}}

In diesem Modus beendet der BOMnipotent Client den Vorgang mit einem Fehlercode genau dann wenn nicht bewertete Schwachstellen vorliegen. Dies erleichtert die Integration dieses Aufrufs in Ihre regelmäßige CI/CD.

Sie können diese Option frei mit der Angabe eines Produktnamens oder einer Version kombinieren:

{{< example vuln_list_unassessed_name >}}
