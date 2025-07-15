+++
title = "Dokumentenverwaltung"
weight = 20
description = "Verwalten Sie Lieferkettensicherheitsdokumente wie BOMs und CSAF-Dokumente effizient mit BOMnipotent. Automatisierte Schwachstellenprüfung inklusive."
+++

BOMnipotent unterstützt zwei Arten von Lieferkettensicherheitsdokumenten: Stücklisten (BOMs) und Common Security Advisory Framework (CSAF)-Dokumente. Darüber hinaus kann es Informationen zu Schwachstellen in Zusammenhang mit einer BOM bereitstellen.

Eine typische Herangehensweise an das Dokumentenmanagement sieht folgendermaßen aus:
1. Eine neue Produktversion wird zusammen mit der zugehörigen BOM veröffentlicht. Die BOM kann beispielsweise mit [syft](/de/integration/syft/) erstellt werden. Dieses Dokument wird auf den Server [hochgeladen](/de/client/manager/doc-management/boms/) hochgeladen. Im Gegensatz zu anderen Dokumenten sollten BOMs als statische Daten behandelt werden. Das Ändern oder Löschen von Stücklisten ist möglich, aber selten.
1. Ein automatisiertes Tool oder Skript lädt die BOMs regelmäßig herunter und prüft sie auf Schwachstellen. Dies kann beispielsweise mit [grype](/de/integration/grype/) erfolgen. Die Ergebnisse werden auf dem Server [aktualisiert](/de/client/manager/doc-management/vulnerabilities/).
1. Ein weiteres Tool oder Skript [prüft](/de/client/manager/doc-management/vulnerabilities/) den BOMnipotent-Server regelmäßig auf neue Schwachstellen und schlägt Alarm, falls eine gefunden wird. Menschliches Denken ist gefragt!
1. Der Mitarbeitende analysiert die Schwachstelle gründlich und ermittelt, ob und wie Ihre Kunden reagieren müssen. Er erstellt ein CSAF-Dokument, beispielsweise mithilfe von [secvisogram](https://github.com/secvisogram/secvisogram). Das CSAF-Dokument wird auf den BOMnipotent-Server [hochgeladen](/de/client/manager/doc-management/csaf-docs/).
1. Ihre Nutzer finden jetzt das neue CSAF-Dokument, wenn sie bei Ihrer Instanz des BOMnipotent-Servers [anfragen](/de/client/consumer/boms/).
