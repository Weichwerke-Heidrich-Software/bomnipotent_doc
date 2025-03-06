+++
title = "Docker Compose"
slug = "docker-compose"
weight = 10
description = "Erfahren Sie, wie Sie den BOMnipotent-Server mit Docker Compose einrichten und direkt aus dem Internet verfügbar machen."
+++

Das empfohlene und einfachste Setup für BOMnipotent Server verwendet [Docker Compose](https://docs.docker.com/compose/).

## Vorgeschlagene Dateistruktur

Die vorgeschlagene Dateistruktur im Favoritenverzeichnis Ihres Servers sieht folgendermaßen aus:
```
├── .env
├── bomnipotent_config
│   ├── config.toml
│   └── config.toml.default
└── compose.yaml
```

Dieses Tutorial führt Sie durch die Dateien und erklärt sie einzeln.

## .env

Der BOMnipotent-Server kommuniziert mit einer Datenbank. Derzeit wird nur [PostgreSQL](https://www.postgresql.org/) als Backend unterstützt. Die Datenbank ist durch ein Passwort geschützt. Es empfiehlt sich, das Passwort in einer separaten .env-Datei zu speichern, anstatt direkt im compose.yaml.

> Der Name der Datei muss ".env" lauten, ansonsten erkennt Docker sie nicht.

Ihre .env-Datei sollte so aussehen:
```
BOMNIPOTENT_DB_PW=<Ihr-Datenbank-Passwort>
```

Falls Sie ein Versionierungssystem zum Speichern Ihres Setups verwenden, vergessen Sie nicht, ".env" zu Ihrer .gitignore oder analogen Ignore-Datei hinzuzufügen!

> Um die Sicherheit ins rechte Licht zu rücken: Die Compose-Datei macht den PostgreSQL-Container **nicht** direkt vom Internet aus erreichbar. Das Passwort wird daher nur für Aufrufe innerhalb des Containernetzwerks verwendet.

## config.toml

BOMnipotent Server benötigt eine Konfigurationsdatei, die in [einem anderen Abschnitt](de/server/configuration/config-file/) ausführlicher erläutert wird.

> Der Name der Datei ist grundsätzlich beliebig, aber der einsatzbereite Docker-Container von BOMnipotent Server ist so eingerichtet, dass er nach "config.toml" sucht.

Eine fast minimale Konfiguration sieht so aus:
```toml {wrap="false" title="config.toml"}
# Die db_url hat die Struktur [db_client]://[Benutzer]:[Passwort]@[Container]:[Port]/[db]
# Beachten Sie, dass ${BOMNIPOTENT_DB_PW} auf eine Umgebungsvariable verweist.
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
# Domain, hinter der der Bomnipotent-Server gehostet wird
domain = "https://<Ihre-Domain>.<Top-Level>"
# Mögliche Werte: error, warning, info, debug, trace
log_level = "info"
# Der Pfad zu Ihrer vollständigen TLS-Zertifikatskette
certificate_chain_path = "/etc/ssl/certs/<Ihre-TLS-Zertifikatskette.crt>"
# Der Pfad zu Ihrem geheimen TLS-Schlüssel
secret_key_path = "/etc/ssl/private/<Ihr-geheimer-TLS-Schlüssel>"

# Herausgeberdaten gemäß dem unten verlinkten CSAF-Standard
[publisher_data]
# Dies ist höchstwahrscheinlich die gewünschte Kategorie
category = "vendor"
# Kontaktdaten sind optional und in freier Form
contact_details = "<Bei Sicherheitsfragen kontaktieren Sie uns bitte unter...>"
name = "<Geben Sie den Namen Ihrer Organisation an>"
# Namespace Ihrer Organisation in Form einer vollständigen URL
namespace = "https://<Ihre Domain>.<Top-Level>"
```
Füllen Sie die Klammern mit Ihren Daten aus.

Die Herausgeberdaten werden verwendet, um dem [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3218-document-property---publisher) zu entsprechen.

Der Namespace der Herausgeberdaten kann und wird sich normalerweise von der Domäne unterscheiden:
* Die Domäne wird verwendet, um auf Ihre BOMnipotent-Serverinstanz zu verweisen, z. B. "https://bomnipotent.wwh-soft.com"
* Der Namespace ist ebenfalls eine URL, wird jedoch verwendet, um Ihre Organisation in verschiedenen Sicherheitsdokumenten zu identifizieren. Im Fall von Weichwerke Heidrich Software ist es "https://wwh-soft.com".

Es wird empfohlen, Ihre config.toml-Datei in einem dedizierten Verzeichnis zu speichern, in diesem Beispiel "bomnipotent_config". Die Docker-Compose-Datei gewährt Lesezugriff auf diesen Ordner. Dieses Setup hat zwei Vorteile:
* Im unwahrscheinlichen Fall einer Sicherheitsverletzung des BOMnipotent Server-Containers hätte ein Angreifer nur Zugriff auf Ihr Konfigurationsverzeichnis und sonst nichts auf Ihrem Server.
* BOMnipotent Server überwacht das Verzeichnis auf Änderungen und versucht, die Konfigurationsdatei neu zu laden, wenn sie geändert wurde. Dies funktioniert **nicht**, wenn nur eine einzige Datei dem Docker-Container zugänglich gemacht wird.

> Viele Konfigurationseinstellungen unterstützen Hot Reloading, d. h. sie können geändert werden, ohne den Server neu zu starten. In der obigen Minimalkonfiguration ist der log_level das sinnvollste Beispiel, welches mir einfällt.

Nachdem Sie Ihre config.toml eingerichtet haben, möchten Sie sie möglicherweise beispielsweise als config.toml.default kopieren, um Ihre ursprüngliche Konfiguration schnell wiederherstellen zu können. Dies ist jedoch völlig optional.

## compose.yaml

In der Compose-Datei geben Sie das Container-Setup an. Sobald es reibungslos läuft, muss es nicht mehr so ​​oft geändert werden, aber wenn Sie Docker noch nicht kennen, kann es einige Zeit dauern, bis Sie es verstanden haben.

> Die Datei muss "compose.yaml" heißen, da kann Docker etwas pingelig sein.

Eine vollständig einsatzbereite Compose-Datei sieht so aus:
{{< tabs >}}
{{% tab title="kommentiert" %}}
```yaml
# Es ist optional, dem Setup einen Namen zu geben, andernfalls wird er von Docker abgeleitet.
name: bomnipotent_server_containers

# Die Docker-Container müssen kommunizieren und benötigen dafür ein Netzwerk.
networks:
  # Dieses Netzwerk benötigt eine Referenz
  bomnipotent_network:
    # Da sich die Container auf demselben Docker-Host befinden, ist "bridge" eine sinnvolle Treiberwahl.
    driver: bridge
    # Es ist in Ordnung, dem Netzwerk denselben Namen wie der Referenz zu geben.
    name: bomnipotent_network

volumes:
  # Definieren Sie das Volume für die dauerhafte Datenspeicherung
  bomnipotent_data:
    driver: local

services:
  bomnipotent_db:
    # Name des Datenbankcontainers
    container_name: bomnipotent_db
    deploy:
      resources:
        limits:
          # Begrenzen Sie die CPU-Auslastung auf 0,5 Kerne
          cpus: "0.5"
          # Begrenzen Sie die Speicherauslastung auf 512 MB
          memory: "512M"
    environment:
      # Legen Sie den Datenbanknamen fest
      POSTGRES_DB: bomnipotent_db
      # Legen Sie den Datenbankbenutzer fest
      POSTGRES_USER: bomnipotent_user
      # Legen Sie das Datenbankkennwort aus der .env-Dateivariable fest
      POSTGRES_PASSWORD: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      # Überprüfen Sie, ob die Datenbank bereit ist
      test: ["CMD-SHELL", "pg_isready -U bomnipotent_user -d bomnipotent_db"]
      # Intervall zwischen Integritätsprüfungen
      interval: 60s
      # Timeout für jede Integritätsprüfung
      timeout: 10s
      # Anzahl der Wiederholungsversuche, bevor der Container als fehlerhaft betrachtet wird
      retries: 5
      # Startzeitraum vor der ersten Integritätsprüfung
      start_period: 10s
    # Verwenden Sie das angegebene PostgreSQL-Image
    # Sie können das Container-Tag nach Belieben anpassen
    image: postgres:17-alpine3.21
    logging:
      # Verwenden Sie den lokalen Protokollierungstreiber
      driver: local
      options:
        # Begrenzen Sie die Protokollgröße auf 10 MB
        max-size: "10m"
        # Bewahren Sie maximal 3 Protokolldateien auf
        max-file: "3"
    networks:
      # Stellen Sie eine Verbindung zum angegebenen Netzwerk her
      - bomnipotent_network
    # Starten Sie den Container neu, wenn er aus einem anderen Grund als einem Benutzerbefehl angehalten wurde
    restart: always
    volumes:
      # Mounten Sie das Volume für die dauerhafte Datenspeicherung
      - bomnipotent_data:/var/lib/postgresql/data

  bomnipotent_server:
    # Name des Servercontainers
    container_name: bomnipotent_server
    depends_on:
      # Stellen Sie sicher, dass der Datenbankdienst fehlerfrei ist, bevor Sie den Server starten
      bomnipotent_db:
        condition: service_healthy
    deploy:
      resources:
        limits:
          # Begrenzen Sie die CPU-Auslastung auf 0,5 Kerne
          cpus: "0.5"
          # Begrenzen Sie die Speicherauslastung auf 512 MB
          memory: "512M"
    environment:
      # Geben Sie das Datenbankkennwort an den Server weiter.
      BOMNIPOTENT_DB_PW: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      # Prüfen Sie, ob der Server fehlerfrei ist
      # Ihr TLS-Zertifikat ist höchstwahrscheinlich für "localhost" nicht gültig
      # Daher das --insecure Flag
      test: ["CMD-SHELL", "curl --fail --insecure https://localhost:8443/health || exit 1"]
      # Intervall zwischen den Integritätsprüfungen
      interval: 60s
      # Timeout für jede Integritätsprüfung
      timeout: 10s
      # Anzahl der Wiederholungsversuche, bevor der Container als fehlerhaft betrachtet wird
      retries: 5
      # Startzeitraum vor dem ersten Integritätscheck
      start_period: 10s
    # Dies ist das offizielle Docker-Image, auf dem eine BOMnipotent-Serverinstanz ausgeführt wird.
    image: wwhsoft/bomnipotent_server:latest
    logging:
      # Verwenden Sie den lokalen Protokollierungstreiber
      driver: local
      options:
        # Begrenzen Sie die Protokollgröße auf 10 MB
        max-size: "10m"
        # Bewahren Sie maximal 3 Protokolldateien auf
        max-file: "3"
    networks:
      # Stellen Sie eine Verbindung zum angegebenen Netzwerk her
      - bomnipotent_network
    ports:
      # Ordnen Sie Port 443 auf dem Host Port 8443 auf dem Container zu
      # Dies ermöglicht die Verbindung über verschlüsselte Kommunikation 
      - target: 8443
        published: 443
    # Starten Sie den Container neu, wenn er aus einem anderen Grund als einem Benutzerbefehl angehalten wurde
    restart: always
    volumes:
      # Mounten Sie den Konfigurationsordner auf dem Host per Bind
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      # Mounten Sie das SSL-Verzeichnis per Bind
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true
```
{{% /tab %}}
{{% tab title="unkommentiert" %}}
```yaml
name: bomnipotent_server_containers

networks:
  bomnipotent_network:
    driver: bridge
    name: bomnipotent_network

volumes:
  bomnipotent_data:
    driver: local

services:
  bomnipotent_db:
    container_name: bomnipotent_db
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    environment:
      POSTGRES_DB: bomnipotent_db
      POSTGRES_USER: bomnipotent_user
      POSTGRES_PASSWORD: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U bomnipotent_user -d bomnipotent_db"]
      interval: 60s
      timeout: 10s
      retries: 5
      start_period: 10s
    image: postgres:17-alpine3.21
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    restart: always
    volumes:
      - bomnipotent_data:/var/lib/postgresql/data

  bomnipotent_server:
    container_name: bomnipotent_server
    depends_on:
      bomnipotent_db:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    environment:
      BOMNIPOTENT_DB_PW: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      test: ["CMD-SHELL", "curl --fail --insecure https://localhost:8443/health || exit 1"]
      interval: 60s
      timeout: 10s
      retries: 5
      start_period: 10s
    image: wwhsoft/bomnipotent_server:latest
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    ports:
      - target: 8443
        published: 443
    restart: always
    volumes:
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true
```
{{% /tab %}}
{{< /tabs >}}

Speichern Sie diese Datei als "compose.yaml". Dann rufen Sie:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
docker compose --detach
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
docker compose -d
```
{{% /tab %}}
{{< /tabs >}}

Ihr Server ist jetzt einsatzbereit!

> Ist er nicht? Bitte [kontaktieren Sie mich](https://www.bomnipotent.de/contact)!

Rufen Sie "docker ps" um den Zustand des Servers zu überprüfen.
