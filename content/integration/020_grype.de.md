+++
title = "Sicherheitslücken entdecken mit Grype"
slug = "grype"
weight = 20
+++

Sobald Ihre SBOM (Software Bill of Materials) erstellt wurde, ist es an der Zeit, sie kontinuierlich auf Schwachstellen zu scannen. Beachten Sie, dass einige Gesetze, wie beispielsweise der Cyber Resilience Act der EU, vorschreiben, dass Produkte ohne bekannte Schwachstellen veröffentlicht werden. Der erste Scan sollte daher vor einer Veröffentlichung erfolgen.

Es gibt verschiedene Tools zur Überprüfung eines Produkts auf Schwachstellen in der Lieferkette. Dieses Tutorial verwendet Grype von Anchore, da es sich gut mit Syft von Anchore aus dem [SBOM tutorial](/de/integration/syft) integriert. Genau wie Syft ist Grype ein Open-Source-Befehlszeilenprogramm.

## Einrichtung

Das offizielle [Grype GitHub Repository](https://github.com/anchore/grype#installation) enthält Installationsanweisungen. Ähnlich wie bei Syft können Sie den Installationspfad (das letzte Argument des Shell-Befehls) auf '~/.local/bin' ändern, da '/usr/local/bin' Root-Berechtigungen zum Ändern erfordert.

## Verwendung

Sobald eine SBOM vorliegt, ist das Scannen auf Schwachstellen sehr einfach:

{{< tabs >}}
{{% tab title="lang" %}}
```bash
grype sbom:./sbom.cdx.json --fail-on low
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
grype sbom:./sbom.cdx.json -f low
```
{{% /tab %}}
{{< /tabs >}}


Beim Ausführen dieses Befehls überprüft Grype  [mehrere Schwachstellendatenbanken](https://github.com/anchore/grype?tab=readme-ov-file#grypes-database) auf Übereinstimmungen mit den im SBOM angegebenen Komponenten. Die Option 'fail-on' sorgt dafür, dass das Programm mit einem Fehlercode ungleich null beendet wird, falls eine Schwachstelle mit mindestens der angegebenen Schwere 'low' gefunden wird.

Die Syntax zum Exportieren eines Schwachstellenberichts, der von BOMnipotent verarbeitet werden kann, ist ähnlich wie bei Syft:

{{< tabs >}}
{{% tab title="lang" %}}
```bash
grype sbom:./sbom.cdx.json --output cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
grype sbom:./sbom.cdx.json -o cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{< /tabs >}}
