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

{{< tabs >}}
{{% tab title="lang" %}}
```
grype sbom:./sbom.cdx.json --fail-on low
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
grype sbom:./sbom.cdx.json -f low
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
 ✔ Scanned for vulnerabilities     [2 vulnerability matches]  
   ├── by severity: 0 critical, 0 high, 2 medium, 0 low, 0 negligible
   └── by status:   2 fixed, 0 not-fixed, 0 ignored 
NAME    INSTALLED  FIXED-IN  TYPE        VULNERABILITY        SEVERITY 
ring    0.17.8     0.17.12   rust-crate  GHSA-4p46-pwfr-66x6  Medium    
rustls  0.23.15    0.23.18   rust-crate  GHSA-qg5g-gv98-5ffh  Medium
[0000] ERROR discovered vulnerabilities at or above the severity threshold
```

Beim Ausführen dieses Befehls überprüft Grype  [mehrere Schwachstellendatenbanken](https://github.com/anchore/grype?tab=readme-ov-file#grypes-database) auf Übereinstimmungen mit den im SBOM angegebenen Komponenten. Die Option 'fail-on' sorgt dafür, dass das Programm mit einem Fehlercode ungleich null beendet wird, falls eine Schwachstelle mit mindestens der angegebenen Schwere 'low' gefunden wird.

Die Syntax zum Exportieren eines Schwachstellenberichts, der von BOMnipotent verarbeitet werden kann, ist ähnlich wie bei Syft:

{{< tabs >}}
{{% tab title="lang" %}}
```
grype sbom:./sbom.cdx.json --output cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
grype sbom:./sbom.cdx.json -o cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{< /tabs >}}

Grype lässt sich leicht mit BOMnipotent kombinieren. Sie können das "bom get" Kommando von BOMnipotent Client verwenden, um den Inhalt einer BOM direkt in die Konsole ausgeben zu lassen, und diesen dann an Grype weitergeben:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom get <BOM-NAME> <BOM-VERSION> | grype --output cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom get <BOM-NAME> <BOM-VERSION> | grype -o cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{< /tabs >}}

