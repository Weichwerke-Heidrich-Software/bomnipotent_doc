+++
title = "SBOMs mit Syft"
slug = "syft"
weight = 20
description = "Lernen Sie, was Software Bills of Materials (SBOMs) sind, warum es sie gibt, und wie Sie sie leicht mit dem Open Source Tool Syft generieren können."
+++

Eine Software Bill of Materials (SBOM) ist eine Liste aller Softwarekomponenten, die in deinem Produkt verwendet werden. Im Kontext der Lieferkettensicherheit dient sie als maschinenlesbare Liste von Elementen, mit der neue Sicherheitslücken abgeglichen werden können, sobald sie bekannt werden.

Es gibt mehrere Tools zur automatischen Erstellung einer solchen SBOM. Dieses Tutorial konzentriert sich auf [Syft](#syft) von Anchore, einem Open-Source-Kommandozeilentool.

## BOMs

### Was sind BOMs?

Die Stückliste (Bill of Material, BOM) ist ein Konzept, das älter ist als Software. Sie listet alle Komponenten auf, die zur Herstellung eines Produkts verwendet wurden. Im Kontext der Sicherheit der Software-Lieferkette ist sie ein strukturiertes, maschinenlesbares Dokument, welches die Komponenten eines Produkts auflistet.

Anfangs wurden BOMs hauptsächlich verwendet, um die Einhaltung verschiedener Lizenzmodelle sicherzustellen: Copyleft-Open-Source-Lizenzen verlangen beispielsweise, dass alle Projekte, die die Abhängigkeit verwenden, selbst unter einer Copyleft-Lizenz vertrieben werden müssen. Mithilfe einer BOM lässt sich überprüfen, dass in einem kommerziellen Produkt keine Software mit Copyleft-Lizenz verwendet wird.

Einige Jahre später erkannte man das enorme Potenzial von BOMs für die Lieferkettensicherheit: Wird eine Sicherheitslücke in einem weit verbreiteten Software Paket bekannt, genügt ein Blick in eine gründliche BOM, um festzustellen, ob ein Produkt diese Sicherheitslücke möglicherweise enthält.

Heute liegt der Fokus auf Automatisierung: Eine BOM kann nahezu kostenlos mit einer öffentlichen Sicherheitslückendatenbank abgeglichen werden, sodass eine [CI/CD-Pipeline](/de/integration/ci-cd/) täglich nach neuen Sicherheitslücken suchen kann. Diese Automatisierung ist der Schlüssel, um die Zeitspanne zwischen dem Bekanntwerden einer Sicherheitslücke in einer Abhängigkeit und ihrer Behebung im Endprodukt drastisch zu verkürzen.

Stücklisten existieren nicht nur für Software:
- [Hardware-Stücklisten](https://cyclonedx.org/capabilities/hbom/) (HBOMs) ähneln am ehesten der klassischen Stückliste.
- [Kryptografie-Stücklisten](https://cyclonedx.org/capabilities/cbom/) (CBOMs) enthalten Informationen darüber, welche kryptografischen Verfahren in einem Projekt verwendet werden.
- [KI-Stücklisten](https://owaspaibom.org/) (AIBOMs) haben in letzter Zeit Aufmerksamkeit bekommen, da sie dokumentieren, wie ein KI-Modell trainiert wurde.

Diese Liste ist weitab von Vollständigkeit.

### Eindeutige Identifikatoren

Der Hauptnutzen einer Stückliste (BOM) aus Sicht der Lieferkettensicherheit liegt darin, dass sie mit Sicherheitslückendatenbanken verglichen werden kann. Um dies zu ermöglichen, benötigt jede Komponente einer Stückliste eine eindeutige, maschinenlesbare Kennung als Suchschlüssel in diesen Datenbanken. Die am weitesten verbreiteten Formate sind CPE und PURL.

> Das stimmt nicht ganz: BOMnipotent kann den Namen und die Version einer Komponente verwenden, um sie CSAF-Sicherheitswarnungen [zuzuordnen](/de/client/consumer/boms/#zuordnen) und so Zugriff auf Sicherheitslücken zu erhalten, die über jene in öffentlichen Datenbanken hinausgehen.

#### CPE

Die [Common Platform Enumeration](https://de.wikipedia.org/wiki/Common_Platform_Enumeration) (CPE) ist ein Verfahren, das primär zur Suche nach Common Vulnerabilities and Exposures (CVEs) verwendet wird. Beide Formate werden vom NIST verwaltet. CPE hat folgendes Format:
```
cpe:<cpe_version>:<part>:<vendor>:<product>:<version>:<update>:<edition>:<language>:<sw_edition>:<target_sw>:<target_hw>:<other>
```
Die meisten Felder erlauben Platzhalterzeichen '*', die alle Ergebnisse des jeweiligen Teils abdecken. Eine gültige CPE für Version 1.3.0 von BOMnipotent ist beispielsweise:
```
cpe:2.3:a:Weichwerke Heidrich Software:BOMnipotent:1.3.0:*:*:*:*:*:*:*
```
Die wichtigsten Bestandteile der CPE sind "product" und "version", da diese von den meisten Algorithmen als Suchschlüssel für Sicherheitslücken verwendet werden.

#### PURL

Der [Package Uniform Resource Locator](https://github.com/package-url/purl-spec) (PURL, nicht zu verwechseln mit dem "Persistent Uniform Resource Locator", ebenfalls PURL) dient einem sehr ähnlichen Zweck wie die [CPE](#cpe), jedoch mit einem engeren Anwendungsbereich. Dies bedeutet, dass er weniger mächtig, aber auch kürzer und einfacher ist.

Das allgemeine Schema lautet:
```
<scheme>:<type>/<namespace>/<name>@<version>?<qualifiers>#<subpath>
```
Von diesen Komponenten sind nur 'Schema', 'Typ' und 'Name' erforderlich. Ein gültiger PURL für Version 1.2.1 von [cwenum](https://github.com/Weichwerke-Heidrich-Software/cwenum) lautet beispielsweise:
```
pkg:cargo/cwenum@1.2.1
```

> Wie der Name suggeriert, sind Paket-URLs ausschließlich für Pakete gedacht. Daher kann die Anwendung BOMnipotent hier nicht als Beispiel dienen.

### Format und Struktur

Die beiden am weitesten verbreiteten Formate für Stücklisten (BOMs) sind [SPDX](https://spdx.dev/) und [CycloneDX](https://cyclonedx.org/). Da CycloneDX einen stärkeren Fokus auf Sicherheitsaspekte legt und beide Formate ineinander konvertiert werden können, konzentriert sich dieser Artikel auf CycloneDX.

> Stand Version 1.3.0 unterstützt BOMnipotent ausschließlich Stücklisten im CycloneDX-Format. Die Unterstützung von SPDX ist derzeit nicht geplant.

CycloneDX ist ein Schema für JSON- oder XML-Format. Es besteht im Wesentlichen aus bis zu vier Abschnitten:
- Das Objekt 'metadata.component' spezifiziert das Produkt, für welches die Stückliste die Komponenten auflistet. Laut Standard ist es optional, eine ordentliche Stückliste sollte jedoch mindestens den Namen und die Version des beschriebenen Produkts enthalten.
- Der Abschnitt 'components' ist das Herzstück der BOM. Er listet alle im Produkt enthaltenen Komponenten auf. Jede Komponente sollte mindestens einen Namen, eine Version, eine [CPE-Kennung](#cpe) und eine [PURL-Kennung](#purl) enthalten.
- Der Abschnitt 'dependencies' wandelt die flache Komponentenliste in einen Abhängigkeitsbaum um. Er enthält die Information, welche Komponente von welcher anderen abhängt. Dies erleichtert zwar das Verständnis des Produkts erheblich für einen Menschen, ist aber optional und hat keinen Einfluss auf die automatische Sicherheitslückenerkennung.
- Eine Stückliste kann um einen Abschnitt 'vulnerabilities' erweitert werden. Jede Sicherheitslücke verweist auf die Komponente, in der sie aufgetreten ist, und enthält typischerweise eine ID, eine Schweregradangabe und eine Beschreibung.

Ein wichtiger Aspekt ist, dass alle Abschnitte der Stückliste außer den Sicherheitslücken als *statische* Informationen gelten, während die Sicherheitslücken *dynamisch* sind: Die Komponentenstruktur einer bestimmten Produktversion ändert sich nicht, während Sicherheitslücken jederzeit nach der Veröffentlichung entdeckt werden können.

> Aus diesem Grund lautet der Befehl von BOMnipotent zum Erstellen einer BOM ["upload"](/de/client/manager/doc-management/boms/#hochladen), während der analoge Befehl für Sicherheitslücken ["update"](/de/client/manager/doc-management/vulnerabilities/#aktualisieren) lautet.

### Umfang

Eine gültige Stückliste (BOM) enthält nicht zwangsläufig alle Komponenten eines Produkts. Sie kann beispielsweise nur die direkten Abhängigkeiten, nicht aber deren Abhängigkeiten umfassen. Bei Software, die in einem Ökosystem mit Paketmanager entwickelt wurde, lässt sich in der Regel sehr einfach eine nahezu vollständige Komponentenliste erstellen -- bei anderer Software oder Hardware ist dies oft nicht der Fall.

Bei der Entscheidung, welche Komponenten in eine Stückliste aufgenommen werden sollen, ist der Umfang der Anwendung entscheidend: Was wird letztendlich an den Kunden ausgeliefert? Handelt es sich um eine Anwendung? Einen Container? Einen Computer mit Betriebssystem? Eine komplette Maschine?

Je nach Antwort auf diese Fragen lässt sich eine vollständige Stückliste derzeit möglicherweise nicht ohne Weiteres mit einem Tool generieren. Insbesondere für Hardwarekomponenten ist es oft notwendig, eine separate Stückliste manuell zu pflegen.

## Syft

Syft ist ein Kommandozeilen-Tool zur Generierung einer Software Stückliste (SBOM). Insbesondere für Softwareprojekte, die einen Paketmanager verwenden, lässt es sich problemlos in einen Workflow integrieren, um mit jeder Version automatisch eine Stückliste zu erstellen.

### Installation und Verwendung

Das offizielle [Syft GitHub Repository](https://github.com/anchore/syft?tab=readme-ov-file#installation) enthält Installationsanweisungen. Die Installation ist über ein Shell-Skript oder verschiedene Paketmanager möglich.

Auf manchen Linux-Systemen sollten Sie den Installationspfad (das letzte Argument des Shell-Befehls) auf "~/.local/bin" ändern, da für Änderungen an "/usr/local/bin" Root-Rechte erforderlich sind.

{{< example install_syft >}}

Die grundlegende Verwendung von Syft lautet:
```
syft <Ziel> [Optionen]
```
Zusätzlich lassen sich einige Konfigurationen über Umgebungsvariablen vornehmen.

Syft unterstützt Lockfiles, Verzeichnisse, Container-Images und weitere Zieltypen.

Sobald die SBOM generiert ist, kann sie mit dem BOMnipotent Client auf dem [BOMnipotent Server hochgeladen](/de/client/manager/doc-management/boms/#hochladen) werden.

Danach können Sie Grype nutzen, um regelmäßig [nach Sicherheitslücken zu scannen](/de/integration/grype/).

### Lockfile

Ein Beispielaufruf sieht folgendermaßen aus:

{{< example syft_lockfile >}}

Erklärung:
- 'SYFT_FORMAT_PRETTY=1' setzt eine Umgebungsvariable, die Syft anweist, durch Menschen besser lesbare Ausgabe zu produzieren. Eine vollständige Liste der Konfigurationen befindet sich [hier](https://github.com/anchore/syft/wiki/configuration).
- 'syft' ruft das Syft-Programm auf.
- 'Cargo.lock' gibt an, dass Syft die Lockfile-Datei des Rust-Ökosystems analysieren soll.
- 'output cyclonedx-json=./sbom.cdx.json' legt fest, dass die Ausgabe im [CycloneDx](https://cyclonedx.org/) JSON-Format in der Datei './sbom.cdx.json' gespeichert wird.
  - Beachten Sie, dass '.cdx.json' die [empfohlene Dateiendung](https://cyclonedx.org/specification/overview/#recognized-file-patterns) ist.
- 'source-name="BOMnipotent"' gibt an, dass diese Quellen zu der Komponente BOMnipotent gehören, was Syft nicht in allen Fällen automatisch erkennen kann.
  - Das CycloneDX-Schema erfordert möglicherweise keinen Komponentennamen, aber BOMnipotent benötigt ihn.
- 'source-version="1.0.0"' gibt Syft die aktuelle Version des Projekts an.
  - Falls keine Version angegeben wird, versucht BOMnipotent, stattdessen den Zeitstempel als Versionszeichenkette zu verwenden.

Syft unterstützt eine Vielzahl von Ökosystemen, welche [in Ihrem GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#supported-ecosystems) aufgelistet sind.

### Verzeichnis

Syft kann auf ein ganzes Verzeichnis angewendet werden, allerdings ist das oft übertrieben. Es durchsucht alle Unterverzeichnisse und erfasst alles, was entfernt wie eine Lockfile aussieht, einschließlich aller Testabhängigkeiten, Entwicklungsskripte und GitHub Actions.

{{< example syft_dir >}}

### Container

Falls Sie einen Docker-Container als '.tar'-Datei exportiert haben, können Sie diesen ebenfalls als Ziel angeben:

{{< tabs >}}
{{% tab title="lang" %}}
```
syft container.tar --output cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
syft container.tar -o cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{< /tabs >}}

Bei kompilierten Sprachen können die Ergebnisse stark abweichen, da die meisten Informationen über die Komponenten, die in die Kompilierung eingeflossen sind, verloren gehen. Andererseits enthält diese SBOM Informationen über die Umgebung, in der das Produkt später möglicherweise ausgeführt wird.
