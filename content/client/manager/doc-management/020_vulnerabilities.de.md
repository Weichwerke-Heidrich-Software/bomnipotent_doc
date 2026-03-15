+++
title = "Sicherheitslücken"
slug = "vulnerabilities"
weight = 20
description = "Erfahren Sie, wie Sie Sicherheitslücken in Ihrer Lieferkette mit BOMnipotent und Tools wie grype erkennen, aktualisieren und auflisten können."
+++

Ein zentraler Bestandteil der Lieferkettensicherheit ist der Abgleich des Inhalts einer Stückliste (BOM), also aller Komponenten eines Produkts, mit Datenbanken bekannter Sicherheitslücken.

> Für Sicherheitslückeninteraktionen, die über das Lesen hinausgehen, benötigen Sie die Berechtigung {{<vuln-management-de>}}. Im Abschnitt zur [Verwaltung von Zugriffsrechten](/de/client/manager/access-management/) wird beschrieben, wie diese erteilt wird.

## Erkennen

Hersteller verteilen Sicherheitslücken in ihren Produkten über eine Vielzahl von Kanälen:
- Das [Open Source Vulnerability (OSV) format](https://ossf.github.io/osv-schema/) wird als Standard von Google entwickelt. Mehrere Datenbanken implementieren is, allen voran die [OSV database](https://osv.dev/).
- Die [National Vulnerability Database (NVD)](https://nvd.nist.gov/) bietet eine REST API.
- Die [European Union Vulnerabilty Database (EUVD)](https://euvd.enisa.europa.eu/) bietet eine andere REST API.
- Öffentliche GitHub Repositories haben einen [Security Advisories Abschnitt](https://docs.github.com/en/code-security/concepts/vulnerability-reporting-and-management/about-repository-security-advisories).
- Jedes sinnvolle CSAF Dokument bezieht sich auf mindestens eine Sicherheitslücke.

Es gibt eine wichtige Unterscheidung zwischen dem letzten und den anderen Fällen: CSAF Dokumente können über ein TLP Label klassifiziert werden, während alle anderen Sicherheitslücken öffentlich verfügbare Informationen sind. Aus diesem Grund sind viele Datenbanken großartige Werkzeuge im Zusammenhang mit Open Source Abhängigkeiten, bei denen Sicherheitslücken in der Regel öffentlich verfügbar gemacht werden, während sie beim Prüfen von Closed Source Produkten an ihre Grenzen stoßen.

BOMnipotent unterstützt beide Arten von Quellen über unterschiedliche Mechanismen.

## Aktualisieren öffentlicher Sicherheitslücken

Ein Tool, das in Kombination mit BOMnipotent verwendet werden kann, ist [grype](https://github.com/anchore/grype/). Es verwendet eine BOM als Eingabe und erstellt eine Liste der Sicherheitslücken als Ausgabe. Das [grype-Tutorial](/de/integration/grype/) enthält weitere Informationen zur Verwendung. Es können aber auch andere Tools verwendet werden, solange sie Output im [CycloneDX JSON Format](https://cyclonedx.org/) erstellen können.

Mit dem BOMnipotent-Client können Sie den Inhalt einer BOM direkt ausgeben und an grype weiterleiten.

{{< example bom_get_grype_output >}}

Dadurch werden die Softwarekomponenten anhand mehrerer Datenbanken geprüft und die Ergebnisse in das CycloneDX eingepflegt. Anschließend werden alle Ergebnisse in einer Datei namens "vuln.cdx.json" (oder einem anderen von Ihnen angegebenen Namen) gespeichert.

> Grype hat derzeit einen kleinen [bekannten Fehler](https://github.com/anchore/grype/issues/2418), der dazu führt, dass die Version der Hauptkomponente beim Hinzufügen der Sicherheitslücken vergessen wird. Dies ist problematisch, da BOMnipotent die Version zur eindeutigen Identifizierung eines Produkts benötigt. Eine mögliche Problemumgehung besteht darin, die Version erneut zum Dokument hinzuzufügen, beispielsweise über `jq '.metadata.component.version = "<VERSION>"' "vuln.cdx.json" > "vuln_with_version.cdx.json"`. Ab BOMnipotent v0.3.1 können Sie die Version stattdessen direkt beim Hochladen der Sicherheitslücke angeben, wie unten beschrieben.

Der Befehl zum Aktualisieren der mit einer BOM verknüpften Sicherheitslücken lautet:

{{< example vuln_update >}}

Das Argument "\<VULNERABILITIES\>" muss ein Pfad zu einer Datei im [CycloneDX JSON-Format](https://cyclonedx.org/) sein.

Idealerweise enthält diese Datei den Namen und die Version der zugehörigen BOM. In diesem Fall werden diese automatisch gelesen. Falls einer der Werte fehlt (z. B. aufgrund eines [bekannten Fehlers](https://github.com/anchore/grype/issues/2418) in grype/), können Sie ihn mit einem optionalen Argument angeben:

{{< example vuln_update_name_version >}}

Sicherheitslücken sollten regelmäßig aktualisiert werden. Dadurch werden alle vorherigen Sicherheitslücken, die mit einer BOM verknüpft sind, vollständig ersetzt. Das hochgeladene CycloneDX-Dokument muss daher eine vollständige Liste aller bekannten Sicherheitslücken enthalten.

Sie können Sicherheitslücken nur für eine BOM aktualisieren, die auf dem Server vorhanden ist:

{{< example vuln_update_nonexistent >}}

## Aktualisieren klassifizierter Sicherheitslücken

Manche Anbieter, insbesondere im Industriesektor, veröffentlichen ihre Sicherheitslücken in der Regel nicht sofort. Das ist verständlich: Sobald eine Sicherheitslücke bekannt ist, kann sie ausgenutzt werden. Stattdessen informieren die Anbieter ihre Kunden üblicherweise über die erforderlichen Maßnahmen und veröffentlichen den Vorfall erst nach einer gewissen Frist.

Der CSAF-Standard wurde entwickelt, um diesen Prozess zu automatisieren. Anbieter laden CSAF-Dokumente auf ihren CSAF-Server hoch, die dann regelmäßig von den Kunden abgefragt werden können.

Ab Version 1.5.0 unterstützt BOMnipotent die zyklische Aufgabe ["download_csafs"](/server/periodic-tasks/unscheduled/download_csafs/). Diese lädt CSAF-Dokumente von einem externen CSAF-Anbieter herunter, gleicht sie mit den Komponenten aller gespeicherten BOMs ab und erstellt basierend auf diesen Übereinstimmungen neue Sicherheitslückeneinträge.

CSAF-Dokumente enthalten einen Status für die betroffenen Produkte, der festlegt, ob für die jeweilige Komponente eine Sicherheitslücke erstellt werden muss. Die Stati "first_affected", "last_affected", "known_affected" und "under_investigation" erzeugen einen Eintrag für eine Sicherheitslücke, während die Stati "fixed", "first_fixed", "known_not_affected" und "recommended" dies nicht tun.

Die resultierende Sicherheitslücke wird selbst klassifiziert. Da es sich um eine Kombination aus einer BOM- und einer CSAF-Datei handelt, die im Allgemeinen unterschiedliche Klassifizierungen aufweisen können, wird das strengere der beiden TLP-Label verwendet. Falls beide Dokumente keine Klassifizierung enthalten, wird das [Standard-TLP-Label](/de/server/configuration/optional/tlp-config/) verwendet.

Die Aufgabe kann mehrfach konfiguriert werden, sodass alle verschiedenen Hersteller Ihrer verwendeten Komponenten unabhängig voneinander abgefragt werden können.

## Auflisten

Der Abschnitt zum [Auflisten von Sicherheitslücken](/de/client/consumer/vulnerabilities/) in der Dokumentation für Verbraucher behandelt die meisten Aspekte der Auflistung von Sicherheitslücken.

Ein Aspekt, der dort nicht erwähnt wird, ist die Option "unassessed". Damit listet der BOMnipotent-Client nur Sicherheitslücken auf, denen kein CSAF-Dokument mit Status "final" zugeordnet ist.

> Damit diese Zuordnung geschehen kann, **muss** das CSAF Dokument [Produktname und Produktversion](/de/integration/secvisogram/#zuordnung-zu-boms) für die BOM in seinen Branches enthalten.

{{< example vuln_list_unassessed >}}

In diesem Modus beendet der BOMnipotent Client den Vorgang mit einem Fehlercode genau dann wenn nicht bewertete Sicherheitslücken vorliegen. Dies erleichtert die Integration dieses Aufrufs in Ihre regelmäßige CI/CD.

Sie können diese Option frei mit der Angabe eines Produktnamens oder einer Version kombinieren:

{{< example vuln_list_unassessed_name >}}
