+++
title = "SBOM-Generierung mit Syft"
slug = "syft"
weight = 10
description = "SBOM-Generierung mit Syft: Einrichtung, Verwendung für Lockfiles, Verzeichnisse und Container, sowie abschließende Bemerkungen zur Zielauswahl und Sicherheitslücken-Scans."
+++

Eine Software Bill of Materials (SBOM) ist eine Liste aller Softwarekomponenten, die in deinem Produkt verwendet werden. Im Kontext der Lieferkettensicherheit dient sie als maschinenlesbare Liste von Elementen, mit der neue Schwachstellen abgeglichen werden können, sobald sie bekannt werden.

Es gibt mehrere Tools zur automatischen Erstellung einer solchen SBOM. Dieses Tutorial konzentriert sich auf Syft von Anchore, einem Open-Source-Kommandozeilentool.

## Einrichtung

Das offizielle [Syft GitHub Repository](https://github.com/anchore/syft?tab=readme-ov-file#installation) enthält Installationsanweisungen. Die Installation ist über ein Shell-Skript oder verschiedene Paketmanager möglich.

Auf manchen Linux-Systemen sollten Sie den Installationspfad (das letzte Argument des Shell-Befehls) auf "~/.local/bin" ändern, da für Änderungen an "/usr/local/bin" Root-Rechte erforderlich sind.

## Verwendung

Die grundlegende Verwendung von Syft lautet:
```bash
syft <Ziel> [Optionen]
```
Zusätzlich lassen sich einige Konfigurationen über Umgebungsvariablen vornehmen.

Syft unterstützt Lockfiles, Verzeichnisse, Container-Images und weitere Zieltypen.

### Lockfile

Ein Beispielaufruf sieht folgendermaßen aus:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
SYFT_FORMAT_PRETTY=1 syft Cargo.lock --output cyclonedx-json=./sbom.cdx.json --source-name="BOMnipotent" --source-version="1.0.0"
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
SYFT_FORMAT_PRETTY=1 syft Cargo.lock -o cyclonedx-json=./sbom.cdx.json --source-name="BOMnipotent" --source-version="1.0.0"
```
{{% /tab %}}
{{< /tabs >}}

Erklärung:
- 'SYFT_FORMAT_PRETTY=1' setzt eine Umgebungsvariable, die Syft anweist, durch Menschen besser lesbare Ausgabe zu produzieren. Eine vollständige Liste der Konfigurationen befindet sich [hier](https://github.com/anchore/syft/wiki/configuration).
- 'syft' ruft das Syft-Programm auf.
- 'Cargo.lock' gibt an, dass Syft die Lockfile-Datei des Rust-Ökosystems analysieren soll.
- '--output cyclonedx-json=./sbom.cdx.json' legt fest, dass die Ausgabe im [CycloneDx](https://cyclonedx.org/) JSON-Format in der Datei './sbom.cdx.json' gespeichert wird.
  - Beachten Sie, dass '.cdx.json' die [empfohlene Dateiendung](https://cyclonedx.org/specification/overview/#recognized-file-patterns) ist.
- '--source-name="BOMnipotent"' gibt an, dass diese Quellen zu der Komponente BOMnipotent gehören, was Syft nicht in allen Fällen automatisch erkennen kann.
  - Das CycloneDX-Schema erfordert möglicherweise keinen Komponentennamen, aber BOMnipotent benötigt ihn.
- '--source-version="1.0.0"' gibt Syft die aktuelle Version des Projekts an.
  - Falls keine Version angegeben wird, versucht BOMnipotent, stattdessen den Zeitstempel als Versionszeichenkette zu verwenden.

Syft unterstützt eine Vielzahl von Ökosystemen, welche [in Ihrem GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#supported-ecosystems) aufgelistet sind.

### Verzeichnis

Syft kann auf ein ganzes Verzeichnis angewendet werden, allerdings ist das oft übertrieben. Es durchsucht alle Unterverzeichnisse und erfasst alles, was entfernt wie eine Lockfile aussieht, einschließlich aller Testabhängigkeiten, Entwicklungsskripte und GitHub Actions.

{{< tabs >}}
{{% tab title="lang" %}}
```bash
syft . --output cyclonedx-json=./dev_env_sbom.cdx.json --source-name="BOMnipotent Entwicklungsumgebung" --source-version=1.2.3
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
syft . -o cyclonedx-json=./dev_env_sbom.cdx.json --source-name="BOMnipotent Entwicklungsumgebung" --source-version=1.2.3
```
{{% /tab %}}
{{< /tabs >}}

### Container

Falls Sie einen Docker-Container als '.tar'-Datei exportiert haben, können Sie diesen ebenfalls als Ziel angeben:

{{< tabs >}}
{{% tab title="lang" %}}
```bash
syft container.tar --output cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
syft container.tar -o cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{< /tabs >}}

Bei kompilierten Sprachen können die Ergebnisse stark abweichen, da die meisten Informationen über die Komponenten, die in die Kompilierung eingeflossen sind, verloren gehen. Andererseits enthält diese SBOM Informationen über die Umgebung, in der das Produkt später möglicherweise ausgeführt wird.

### Abschließende Bemerkungen

Bei der Auswahl eines Ziels ist es wichtig, den Umfang der Anwendung zu berücksichtigen:
Was wird an den Kunden ausgeliefert? In welchem Umfang sind Sie für die Lieferkette des Produkts verantwortlich? Bei Unentschlossenheit spricht nichts dagegen, mehrere Varianten einer SBOM hochzuladen – solange der Produktname oder die Version unterschiedlich ist.

Sobald die SBOM generiert ist, kann sie mit dem BOMnipotent Client auf dem [BOMnipotent Server hochgeladen](/de/client/manager/doc-management/uploading-boms/) werden.

Danach können Sie Grype nutzen, um regelmäßig [nach Sicherheitslücken zu scannen](/de/integration/grype).
