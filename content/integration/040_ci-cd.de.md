+++
title = "CI/CD"
slug = "ci-cd"
weight = 40
description = "Anleitung zur Integration von BOMnipotent in CI/CD-Pipelines: BOM-Upload, Sicherheitslückenprüfung und Automatisierung mit GitHub Actions."
+++

BOMnipotent wurde für die Automatisierung entwickelt. Es fordert den Nutzer nie zur interaktiven Eingabe auf und ist damit vollständig skriptbar.

Diese Seite beschreibt, wie Sie den BOMnipotent-Client in Ihrer CI/CD-Pipeline verwenden, um mit jedem Release BOMs hochzuladen und täglich auf Schwachstellen zu prüfen.

Weichwerke Heidrich Software hat mehrere einsatzbereite GitHub-Actions zur Integration von BOMnipotent in Ihre Pipeline entwickelt. Die meisten davon basieren auf Bash-Skripten, um die Übertragung in andere Pipeline-Umgebungen so einfach und nahtlos wie möglich zu gestalten.

## Voraussetzungen

Dieses Setup setzt voraus, dass Sie eine BOMnipotent-Serverinstanz installiert haben. Falls dies noch nicht der Fall ist, lesen Sie die [Setup-Anleitung](/de/server/setup/).

Die Pipeline erfordert außerdem, dass der Server über ein genehmigtes [Roboter-Benutzerkonto](/de/client/manager/access-management/robot-users/) mit den Berechtigungen {{<bom-management-de>}} und {{<vuln-management-de>}} verfügt.

## BOMnipotent-Client einrichten

Die Bereitstellung ausführbarer Dateien ist der Bereich, in dem sich die verschiedenen Pipeline-Umgebungen am meisten unterscheiden. Glücklicherweise ist dies auch die Hürde, die DevOps-Ingenieure sehr früh überwinden. Daher wird diese Aufgabe derzeit nur für GitHub-Actions beschrieben, für die ein einsatzbereiter Schritt vorhanden ist.

### GitHub-Action

Die Action zum Einrichten von BOMnipotent Client finden Sie im [GitHub Marketplace](https://github.com/marketplace/actions/setup-bomnipotent-client).

Ein typischer Ausschnitt aus Ihrer Workflow-YAML-Datei sieht wie folgt aus (mit Ausnahme der Einrückung, weil YAML...):

```yaml {{ title="Typischer Setup Ausschnitt" }}
- name: Installieren von BOMnipotent Client
  uses: Weichwerke-Heidrich-Software/setup-bomnipotent-action@v1
  with:
    domain: '<Ihre-Server-Domain>'
    user: '<Ihr-Roboter-Nutzer>'
    secret-key: ${{ secrets.CLIENT_SECRET_KEY }} 
```

Ein ausführlicheres Beispiel finden Sie auf [GitHub](https://github.com/marketplace/actions/setup-bomnipotent-client).

Die drei Parameter sind optional, werden aber empfohlen:
- domain: Geben Sie die vollständige Domäne (einschließlich Subdomäne) für Ihre BOMnipotent-Serverinstanz an. Diese wird in einer Sitzung gespeichert, sodass Sie sie bei nachfolgenden Aufrufen nicht erneut angeben müssen.
- user: Speichern Sie den Benutzernamen Ihres Roboterbenutzers, den Sie im Abschnitt [Voraussetzungen](#voraussetzungen) eingerichtet haben.
- secret-key: Geben Sie eine Referenz auf den geheimen Schlüssel an, der zur Authentifizierung des Roboterbenutzers verwendet wird. Sie können ihn Ihrer Pipeline über \<your repo\> → Einstellungen → Geheimnisse und Variablen → Aktionen → Neues Repository-Geheimnis zur Verfügung stellen. Im obigen Beispiel heißt er "CLIENT_SECRET_KEY".

> **Achtung:** Speichern Sie Ihren geheimen Schlüssel nicht direkt in der Pipeline oder einer anderen versionierten Datei. Genau dafür ist der GitHub-Secret-Mechanismus konzipiert.

Nach Ausführung dieser Aktion steht der Befehl "bomnipotent_client.exe" (Windows) bzw. "bomnipotent_client" (UNIX) für den Rest des Jobs zur Verfügung. Da verschiedene Jobs in unterschiedlichen Containern ausgeführt werden, kann es erforderlich sein, die Setup-Aktion im Laufe des Workflows mehrmals aufzurufen.

## BOMs hochladen

Eine Stückliste / Bill of Material (BOM) ist eine Liste der Komponenten eines Produkts. Da es sich um ein *statisches* Dokument handelt, ist jede BOM eng mit einem bestimmten Release des Produkts verknüpft. Ändern sich die Komponenten des (veröffentlichten) Produkts, sollte dieses mit einer neuen Version versehen und einer neuen BOM zugeordnet werden.

Deshalb sollte das Hochladen einer BOM auf den Server als Teil der Release-Pipeline ausgeführt werden.

Gemäß dem Single Responisbility Prinzip sind für das Hochladen von Stücklisten einige Voraussetzungen erforderlich:
– Der BOMnipotent Client Befehl muss verfügbar sein. Es gibt eine [separate Action](#bomnipotent-client-einrichten), die genau das sicherstellt.
– Die Action benötigt als Eingabe eine BOM im CycloneDX-Format, die zuvor generiert werden muss.

Die Erstellung einer BOM ist sehr produktspezifisch. Das ideale Tool hängt vom jeweiligen Ökosystem und dessen Nutzung ab. [Syft](/de/integration/syft/) ist ein Tool, das Sie dabei unterstützen kann und eine einsatzbereite [GitHub-Action](https://github.com/anchore/sbom-action) bereitstellt. Es ist jedoch bei weitem nicht die einzige Option: Das [CycloneDX Tool Center](https://cyclonedx.org/tool-center/) bietet zahlreiche Alternativen.

### GitHub-Action

Ein häufiges Muster besteht darin, die Release-Pipeline durch das Pushen eines Tags auszulösen, welches einer semantischen Version entspricht:

```yaml {{ title="Tag Auslöser" }}
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
```

Nachdem der BOMnipotent-Client eingerichtet und die BOM generiert wurde, kann es mit dem folgenden Ausschnitt hochgeladen werden:

```yaml {{ title="Typischer Hochladen Ausschnitt" }}
- name: BOM Hochladen
  uses: Weichwerke-Heidrich-Software/upload-bom-action@v1
  with:
    bom: './bom.cdx.json'
    name: '${{ github.event.repository.name }}'
    version: '${{ github.ref_name }}'
    tlp: 'amber'
```

Die Action akzeptiert mehrere Argumente:
- bom: Dies ist das einzige obligatorische Argument. Es muss auf eine vorhandene Datei verweisen, die eine BOM im CycloneDX-Format enthält. In diesem Beispiel wurde die Stückliste unter "./bom.cdx.json" gespeichert.
- name / version: Der CycloneDX-Standard erfordert für eine BOM keinen Namen und keine Version, BOMnipotent hingegen schon. Falls das zur Erstellung der Stückliste verwendete Tool die Festlegung von Name und/oder Version nicht ermöglicht, können Sie diese über Argumente überschreiben. Im obigen Beispiel wird der Repository-Name als Produktname und das auslösende Tag als Version verwendet. Alternativ können Sie auch einen Dateipfad angeben: Die Zeile `version: './version.txt'` weist die Aktion beispielsweise an, die Datei "./version.txt" zu lesen und den Inhalt als Versionszeichenfolge zu verwenden.
- tlp: Sie können ein TLP-Label angeben, um die hochgeladene Stückliste zu klassifizieren. Falls nicht angegeben, gilt das [Default-TLP](/de/server/configuration/optional/tlp-config/#default-tlp) des Servers.

Eine vollständige Liste der Argumente finden Sie auf dem [GitHub Marketplace](https://github.com/marketplace/actions/upload-bom-to-bomnipotent-server).

### Andere Pipeline

Die GitHub-Action ist lediglich ein Wrapper für ein Bash-Skript. Um eine BOM über Ihre Pipeline-Infrastruktur hochzuladen, können Sie das [Skript](https://github.com/Weichwerke-Heidrich-Software/upload-bom-action/blob/main/upload_bom.sh) aus dem Repository herunterladen und verwenden.

```
if [ ! -f ./upload_bom.sh ]; then
    curl https://raw.githubusercontent.com/Weichwerke-Heidrich-Software/upload-bom-action/refs/heads/main/upload_bom.sh > ./upload_bom.sh
    chmod +x ./upload_bom.sh
fi
./upload_bom.sh <bom.cdx.json> <optional args...>
```

Das Skript verwendet dieselben Argumente wie die Aktion, mit der Ausnahme, dass das Argument "bom" positionell ist und optionalen Argumenten ein doppelter Bindestrich vorangestellt werden muss:

```
./upload_bom.sh ./bom.cdx.json --name <product-name> --version <product-version> --tlp amber
```

## Auf Sicherheitslücken prüfen

BOMs selbst sind zwar statische Objekte, die die Zusammensetzung eines Produkts dokumentieren, sie müssen aber regelmäßig auf Sicherheitslücken geprüft werden. Die meisten Datenbanken von Sicherheitslücken werden täglich aktualisiert, daher sollten Prüfungen ähnlich häufig durchgeführt werden.

Die BOMnipotent Vulnerability Action umfasst zwei Schritte:
– Aktualisierung der bekannten Sicherheitslücken aller BOMs auf dem Server.
– Überprüfung des Servers auf neue, noch nicht bewertete Sicherheitslücken.

Beide Schritte können einzeln übersprungen werden, falls sie für Ihren Anwendungsfall nicht relevant sind.

### GitHub-Action

Um die Sicherheitslückenprüfung beispielsweise täglich um 3:00 Uhr morgens auszuführen, fügen Sie Ihrem Workflow-YAML-Dokument den folgenden Trigger hinzu:

```yaml {{ title="Regelmäßiger Auslöser" }}
on:
  schedule:
    - cron: '0 3 * * *' # Runs the workflow every day at 03:00 UTC
```

Sobald sie auf dem Agent [BOMnipotent Client aufgesetzt haben](#bomnipotent-client-einrichten), ist der Ausschnitt zur Handhabung der Sicherheitslücken sehr einfach:

```yaml {{ title="Typical vulnerability snippet" }}
- name: Update Vulnerabilities
  uses: Weichwerke-Heidrich-Software/vulnerability-action@v1
```

Ein vollständiges Beispiel finden Sie im [GitHub Marketplace](https://github.com/marketplace/actions/bomnipotent-server-vulnerability-check).

Das Skript lädt alle dem Robernutzer zugänglichen BOMs herunter, gleicht sie mit mehreren Datenbanken bekannter Sicherheitslücken ab, und aktualisiert sie auf dem Server.

Anschließend prüft es, ob noch nicht bewertete Sicherheitslücken vorhanden sind. Eine Sicherheitslücke gilt als nicht bewertet, wenn BOMnipotent-Server kein ihr zugeordnetes [CSAF-Dokument](https://www.csaf.io/) enthält.

### Andere Pipeline

Analog zum [Upload-Schritt](#boms-hochladen) ist diese Action im Wesentlichen ein Wrapper für ein Bash-Skript. Sie können das [Skript](https://github.com/Weichwerke-Heidrich-Software/vulnerability-action/blob/main/update_vulns.sh) im Repository referenzieren oder direkt herunterladen und verwenden:

```
if [ ! -f ./upload_bom.sh ]; then
    curl https://raw.githubusercontent.com/Weichwerke-Heidrich-Software/vulnerability-action/refs/heads/main/update_vulns.sh > ./update_vulns.sh
    chmod +x ./update_vulns.sh
fi
./update_vulns.sh
```

Das Skript verwendet intern [grype](/de/integration/grype/) um auf Sicherheitslücken zu prüfen. Falls Sie das Skript direkt verwenden müssen Sie sicherstellen, dass das Programm installiert ist.
