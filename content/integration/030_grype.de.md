+++
title = "Sicherheitslücken mit Grype"
slug = "grype"
weight = 30
description = "Erfahren Sie, wie Sie mit Grype SBOMs auf Sicherheitslücken scannen und Berichte für die Software-Lieferkettensicherheit erstellen."
+++

Sobald Ihre SBOM (Software Bill of Materials) erstellt wurde, ist es an der Zeit, sie kontinuierlich auf Schwachstellen zu scannen. Beachten Sie, dass einige Gesetze, wie beispielsweise der Cyber Resilience Act der EU, vorschreiben, dass Produkte ohne bekannte Schwachstellen veröffentlicht werden. Der erste Scan sollte daher vor einer Veröffentlichung erfolgen.

Es gibt verschiedene Tools zur Überprüfung eines Produkts auf Schwachstellen in der Lieferkette. Dieses Tutorial verwendet Grype von Anchore, da es sich gut mit Syft von Anchore aus dem [SBOM tutorial](/de/integration/syft) integriert. Genau wie Syft ist Grype ein Open-Source-Befehlszeilenprogramm.

## Einrichtung

Das offizielle [Grype GitHub Repository](https://github.com/anchore/grype#installation) enthält Installationsanweisungen. Ähnlich wie bei Syft können Sie den Installationspfad (das letzte Argument des Shell-Befehls) auf '~/.local/bin' ändern, da '/usr/local/bin' Root-Berechtigungen zum Ändern erfordert.

## Verwendung

Sobald eine SBOM vorliegt, ist das Scannen auf Schwachstellen sehr einfach:

{{< example grype >}}

Beim Ausführen dieses Befehls überprüft Grype  [mehrere Schwachstellendatenbanken](https://github.com/anchore/grype?tab=readme-ov-file#grypes-database) auf Übereinstimmungen mit den im SBOM angegebenen Komponenten. Die Option 'fail-on' sorgt dafür, dass das Programm mit einem Fehlercode ungleich null beendet wird, falls eine Schwachstelle mit mindestens der angegebenen Schwere 'low' gefunden wird.

Die Syntax zum Exportieren eines Schwachstellenberichts, der von BOMnipotent verarbeitet werden kann, ist ähnlich wie bei Syft:

{{< example grype_output >}}

Grype lässt sich leicht mit BOMnipotent kombinieren. Sie können das "bom get" Kommando von BOMnipotent Client verwenden, um den Inhalt einer BOM direkt in die Konsole ausgeben zu lassen, und diesen dann an Grype weitergeben:

{{< example bom_get_grype_output >}}
