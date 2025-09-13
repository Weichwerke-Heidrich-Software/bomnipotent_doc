+++
title = "Docker Compose inkl. Reverse Proxy"
slug = "docker-compose-with-proxy"
weight = 20
description = "Ein Leitfaden zur Einrichtung eines BOMnipotent-Servers mit Docker Compose und nginx Reverse-Proxy, inklusive Dateistruktur und Konfigurationsbeispielen."
+++

Diese Variante des sehr [ähnlichen Setups](/de/server/setup/starting/docker-compose/) mit [Docker Compose](https://docs.docker.com/compose/) richtet nicht nur einen laufenden BOMnipotent-Server ein, sondern auch einen [nginx](https://nginx.org/en/) Reverse-Proxy.

## Vorgeschlagene Dateistruktur

Die vorgeschlagene Dateistruktur im Lieblingsverzeichnis Ihres Servers sieht folgendermaßen aus:
```
├── .env
├── bomnipotent_config
│   ├── config.toml
│   ├── config.toml.default
│   ├── open_pgp_public_key.asc
│   └── open_pgp_secret_key.asc
├── proxy_config
│   └── conf.d
│       └── default.conf
└── compose.yaml
```

Dieses Tutorial führt Sie durch die Dateien und erklärt sie einzeln.

## proxy_config/conf.d/default.conf

> Die Verwendung von nginx als Reverse-Proxy ist lediglich ein Vorschlag. Sie können ihn durch jede andere Serversoftware Ihrer Wahl ersetzen.

Vereinfacht ausgedrückt dient der Reverse-Proxy als Tor zu Ihrem Server: Er ermöglicht Ihnen, mehrere Dienste (BOMnipotent-Server, eine Website usw.) hinter derselben IP-Adresse zu hosten. Jede Anfrage an eine Ihrer URLs landet beim Reverse-Proxy, der sie dann an den richtigen Dienst weiterleitet. So landen Sie beim Besuch von [**doc**.bomnipotent.de](https://doc.bomnipotent.de/de) auf einer anderen Website als beim Besuch von [**www**.bomnipotent.de](https://www.bomnipotent.de/de), obwohl beide hinter derselben IP-Adresse gehostet werden.

Nginx sucht seine Konfiguration an verschiedenen Orten. Später in der [compose.yaml](#composeyaml) verwenden wir Mount-Binding, um unsere Konfiguration hinterrücks in den Nginx-Docker-Container einzuschleusen.

Sie können Folgendes als Ausgangspunkt für Ihre default.conf verwenden:
``` php
# Anfragenbegrenzung: Erlaubt bis zu 5 Anfragen pro Sekunde pro IP-Adresse, gespeichert in einem 10 MB großen Speicherbereich.
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;

# BOMnipotent Server
server {
    # Hierdurch hört der Server auf Port 443, der typischerweise für HTTPS verwendet wird.
    listen 443 ssl http2;
    # Ersetzen Sie dies durch die tatsächliche Domain Ihres BOMnipotent Servers.
    server_name bomnipotent.your-domain.com;

    # Ersetzen Sie dies durch das tatsächliche Zertifikat Ihrer Domain.
    ssl_certificate /etc/ssl/certs/your-domain-fullchain.crt;
    # Ersetzen Sie dies durch den tatsächlichen privaten Schlüssel Ihres Zertifikats.
    ssl_certificate_key /etc/ssl/private/your-domain_private_key.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384";

    location / {
        # Anfragenbegrenzung anwenden
        limit_req zone=api_limit burst=10 nodelay;

        # Dies weist nginx an, Anfragen an Port 8080 des Docker-Containers weiterzuleiten.
        proxy_pass http://bomnipotent_server:8080;
        proxy_set_header Host $host;
        # Die folgenden Zeilen stellen sicher,
        # dass die BOMnipotent-Logs die IP des Absenders enthalten,
        # anstelle der lokalen IP des Reverse-Proxys.
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Sie möchten wahrscheinlich weitere "Server" Blöcke hinzufügen -- warum sonst würden Sie sich für die Einrichtung eines Reverse-Proxy entscheiden?

## .env

BOMnipotent-Server benötigt einige geschützte Informationen. Dazu gehören die Passwörter für die SQL Datenbank, für den geheimen OpenPGP Schlüssel, und für den SMTP Server.

Es empfiehlt sich, diese Passwörter in einer separaten .env-Datei zu speichern, anstatt direkt im compose.yaml.

> Der Name der Datei muss ".env" lauten, ansonsten erkennt Docker sie nicht.

Ihre .env-Datei sollte so aussehen:
```
BOMNIPOTENT_DB_PW=<Ihr-Datenbank-Passwort>
PGP_PASSPHRASE=<Die-Passphrase-zu-Ihrem-OpenPGP-Schlüssel>
SMTP_SECRET=<Ihr-SMTP-Authentifizierungs-Geheimnis>
```

> [!NOTE]
> Falls Sie ein Versionierungssystem zum Speichern Ihres Setups verwenden, vergessen Sie nicht, ".env" zu Ihrer .gitignore oder analogen Ignore-Datei hinzuzufügen!

## config.toml

BOMnipotent Server benötigt eine Konfigurationsdatei, die in [einem anderen Abschnitt](/de/server/configuration/config-file/) ausführlicher erläutert wird.

> Der Name der Datei ist grundsätzlich beliebig, aber der einsatzbereite Docker-Container von BOMnipotent Server ist so eingerichtet, dass er nach "config.toml" sucht.

Eine minimale Konfiguration für einen BOMnipotent Server hinter einem Reverse-Proxy sieht so aus:
```toml {wrap="false" title="config.toml"}
# Die db_url hat die Struktur [db_client]://[Benutzer]:[Passwort]@[Container]:[Port]/[db]
# Beachten Sie, dass ${BOMNIPOTENT_DB_PW} auf eine Umgebungsvariable verweist.
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
# Domain, hinter der der Bomnipotent-Server gehostet wird
domain = "https://bomnipotent.<Ihre-Domain>.<Top-Level>"

# Optional, aber empfohlen
[open_pgp]
# Der Pfad zu Ihrem öffentlichen OpenPGP Schlüssel
public_key_path = "/etc/bomnipotent_server/configs/open_pgp_public_key.asc"
# Der Pfad zu Ihrem geheimen OpenPGP Schlüssel
secret_key_path = "/etc/bomnipotent_server/configs/open_pgp_secret_key.asc"
# Eine optionale Passphrase um auf ihren geheimen OpenPGP Schlüssel zuzugreifen
passphrase = "${PGP_PASSPHRASE}"

[tls]
# Die TLS-Verschlüsselung erfolgt über den Reverse-Proxy,
# der BOMnipotent-Server ist nicht direkt über das Internet erreichbar.
allow_http = true

[smtp]
# Der Nutzername für den Mail-Anbieter, üblicherweise Ihre Mail Adresse
user = "<you@yourdomain.com>"
# Der SMTP Endpunkt Ihres Mail-Anbieters
endpoint = "<your.smtp.host>"
# Das Geheimnis um sich gegenüber dem Mail-Anbieter zu authentifizierenn, üblicherweise Ihr Passwort
secret = "${SMTP_SECRET}"

# Herausgeberdaten gemäß dem unten verlinkten CSAF-Standard
[provider_metadata.publisher]
name = "<Geben Sie den Namen Ihrer Organisation an>"
# Namespace Ihrer Organisation in Form einer vollständigen URL
namespace = "https://<Ihre Domain>.<Top-Level>"
# Dies ist höchstwahrscheinlich die gewünschte Kategorie
category = "vendor"
# Kontaktdaten sind optional und in freier Form
contact_details = "<Bei Sicherheitsfragen kontaktieren Sie uns bitte unter...>"
```
Füllen Sie die Klammern mit Ihren Daten aus.

Falls Sie es bevorzugen, eine lokal laufende SMTP Relay Station zu nutzen, schauen Sie sich die [notwendigen Anpassungen](/de/integration/smtp-server/#kommunikation-über-smtp-relay) der compose Datei an.

Die Herausgeberdaten werden verwendet, um dem [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3218-document-property---publisher) zu entsprechen.

> Der [Abschnitt über Provider-Metadata](/de/server/configuration/required/provider-metadata/) enthält mehr Details dazu was die verschiedenen Felder bedeuten.

Es wird empfohlen, Ihre config.toml-Datei in einem dedizierten Verzeichnis zu speichern, in diesem Beispiel "bomnipotent_config". Die Docker-Compose-Datei gewährt Lesezugriff auf diesen Ordner. Dieses Setup hat zwei Vorteile:
- Im unwahrscheinlichen Fall einer Sicherheitsverletzung des BOMnipotent Server-Containers hätte ein Angreifer nur Zugriff auf Ihr Konfigurationsverzeichnis und sonst nichts auf Ihrem Server.
- BOMnipotent Server überwacht das Verzeichnis auf Änderungen und versucht, die Konfigurationsdatei neu zu laden, wenn sie geändert wurde. Dies funktioniert **nicht**, wenn nur eine einzige Datei dem Docker-Container zugänglich gemacht wird.

> Viele Konfigurationseinstellungen unterstützen Hot Reloading, d. h. sie können geändert werden, ohne den Server neu zu starten.

Nachdem Sie Ihre config.toml eingerichtet haben, möchten Sie sie möglicherweise beispielsweise als config.toml.default kopieren, um Ihre ursprüngliche Konfiguration schnell wiederherstellen zu können. Dies ist jedoch völlig optional.

## open_pgp_*_key.asc

OpenPGP ist ein Standard zum Verschlüsseln und Signieren von Dateien und Nachrichten. Eine [andere Seite](/de/integration/open-pgp/) dieser Dokumentation bietet einen Überblick sowie einen leichten Einstieg in das Thema.

Der geheime Schlüssel wird verwendet, um heruntergeladene [BOMs](/de/client/consumer/boms/#herunterladen) und [CSAF Dokumente](/de/client/consumer/csaf-docs/#herunterladen) zu signieren.

Falls Ihr geheimer Schlüssel durch eine Passphrase geschützt ist, müssen Sie diese in der [.env](#env) Datei angeben und in der [config.toml](#configtoml) verwenden. Andernfalls können Sie das Argument weglassen.

Der öffentliche Schlüssel wird von den Verwendern Ihres Servers benötigt, um die Signatur zu überprüfen. Er ist deswegen unter der URL "\<Ihre-Domain\>/openpgp-key.asc" zu finden.

> BOMnipotent Server bemerkt, falls Sie aus Versehen öffentlichen und geheimen Schlüssel vertauschen, oder falls diese nicht zusammenpassen.

Nur falls Sie beide Schlüsseldateien in der [config.toml](#configtoml) angeben darf BOMnipotent Server sie als [csaf_trusted_provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#723-role-csaf-trusted-provider) ausweisen.

## compose.yaml

In der Compose-Datei geben Sie das Container-Setup an. Sobald es reibungslos läuft, muss es nicht mehr so ​​oft geändert werden, aber wenn Sie Docker noch nicht kennen, kann es einige Zeit dauern, bis Sie es verstanden haben.

> Die Datei muss "compose.yaml" heißen, da kann Docker etwas pingelig sein.

Eine vollständig einsatzbereite Compose-Datei sieht so aus:
{{< tabs >}}
{{% tab title="annotated" %}}
```yaml
# Die Namensgebung für das Setup ist optional, andernfalls wird der Name von Docker hergeleitet.
name: bomnipotent_server_containers

# Die Docker-Container müssen kommunizieren und benötigen dafür ein Netzwerk.
networks:
  # Dieses Netzwerk benötigt eine Referenz.
  bomnipotent_network:
    # Da sich die Container auf demselben Docker-Host befinden, ist "bridge" eine sinnvolle Treiberwahl.
    driver: bridge
    # Es ist zulässig, dem Netzwerk denselben Namen wie der Referenz zu geben.
    name: bomnipotent_network
  # Der Reverse-Proxy muss mit dem BOMnipotent-Server kommunizieren, nicht jedoch mit der Datenbank.
  proxy_network:
    driver: bridge
    name: proxy_network

volumes:
  # Definieren Sie das Volume für die persistente Speicherung der Datenbank.
  bomnipotent_data:
    driver: local
  # Der Server selbst benötigt ebenfalls Persistenz, wenn das Abonnement nicht nach jedem Neustart aktiviert werden soll.
  bomnipotent_subscription:
    driver: local

services:
  reverse_proxy:
    # Name des Reverse-Proxy-Containers
    container_name: reverse_proxy
    deploy:
      resources:
        limits:
          # Begrenzen Sie die CPU-Auslastung auf 0,5 Kerne.
          cpus: "0.5"
          # Begrenzen Sie die Speichernutzung auf 512 MB.
          memory: "512M"
    healthcheck:
      # Prüfen Sie, ob Nginx läuft und die Konfiguration analysieren kann.
      test: ["CMD-SHELL", "nginx -t || exit 1"]
      # Intervall zwischen Integritätsprüfungen
      interval: 60s
      # Timeout für jede Integritätsprüfung
      timeout: 10s
      # Anzahl der Wiederholungsversuche, bevor der Container als fehlerhaft eingestuft wird
      retries: 3
      # Startzeitraum vor der ersten Integritätsprüfung
      start_period: 60s
    image: nginx:latest
    logging:
      # Lokalen Protokolltreiber verwenden
      driver: local
      options:
        # Protokollgröße auf 10 MB begrenzen
        max-size: "10m"
        # Maximal 3 Protokolldateien speichern
        max-file: "3"
    networks:
      # Mit dem angegebenen Netzwerk verbinden
      - proxy_network
    ports:
      # Port 443 des Containers freigeben
      # Dies ermöglicht eine verschlüsselte Verbindung über das Internet
      - "443:443"
    # Container neu starten, falls er aus einem anderen Grund als einem Benutzerbefehl gestoppt wurde
    restart: on-failure
    volumes:
      # Bind-Mount des SSL-Verzeichnisses, damit nginx das TLS-Zertifikat und den Schlüssel findet.
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true
      # Bind-Mount des Konfigurationsordners auf dem Host
      - type: bind
        source: ./proxy_config/conf.d
        target: /etc/nginx/conf.d
        read_only: true

  bomnipotent_db:
    # Name des Datenbankcontainers
    container_name: bomnipotent_db
    deploy:
      resources:
        limits:
          # CPU-Auslastung auf 0,5 Kerne begrenzen
          cpus: "0.5"
          # Speichernutzung auf 512 MB begrenzen
          memory: "512M"
    environment:
      # Datenbanknamen festlegen
      POSTGRES_DB: bomnipotent_db
      # Datenbankbenutzer festlegen
      POSTGRES_USER: bomnipotent_user
      # Datenbankpasswort aus der Variable der .env-Datei festlegen
      POSTGRES_PASSWORD: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      # Prüfen, ob die Datenbank bereit ist
      test: ["CMD-SHELL", "pg_isready -U bomnipotent_user -d bomnipotent_db"]
      # Intervall zwischen Integritätsprüfungen
      interval: 60s
      # Timeout für jede Integritätsprüfung
      timeout: 10s
      # Anzahl der Wiederholungsversuche, bevor der Container als fehlerhaft eingestuft wird
      retries: 5
      # Startzeitraum vor der ersten Integritätsprüfung
      start_period: 10s
    # Das angegebene PostgreSQL-Image verwenden
    # Sie können den Container-Tag nach Belieben anpassen
    image: postgres:17
    logging:
      # Lokalen Logging-Treiber verwenden
      driver: local
      options:
        # Log-Größe auf 10 MB begrenzen
        max-size: "10m"
        # Maximal 3 Log-Dateien speichern
        max-file: "3"
    networks:
      # Mit dem angegebenen Netzwerk verbinden
      - bomnipotent_network
    # Container neu starten, wenn er aus einem anderen Grund als einem Benutzerbefehl gestoppt wurde.
    restart: always
    volumes:
      # Volume für persistente Datenspeicherung mounten
      - bomnipotent_data:/var/lib/postgresql/data

  bomnipotent_server:
    # Name des Server-Containers
    container_name: bomnipotent_server
    depends_on:
      # Sicherstellen, dass der Datenbankdienst fehlerfrei ist, bevor der Server gestartet wird.
      bomnipotent_db:
        condition: service_healthy
    deploy:
      resources:
        limits:
          # CPU-Auslastung auf 0,5 Kerne begrenzen.
          cpus: "0.5"
          # Speichernutzung auf 512 MB begrenzen.
          memory: "512M"
    environment:
      # Datenbankpasswort an den Server weitergeben.
      BOMNIPOTENT_DB_PW: ${BOMNIPOTENT_DB_PW}
      # Geben Sie das SMTP Geheimnis an den Server weiter.
      SMTP_SECRET: ${SMTP_SECRET}
    healthcheck:
      # Servergesundheit überprüfen
      test: ["CMD-SHELL", "curl --fail http://localhost:8080/health || exit 1"]
      # Intervall zwischen Integritätsprüfungen
      interval: 60s
      # Timeout für jede Integritätsprüfung
      timeout: 10s
      # Anzahl der Wiederholungsversuche, bevor der Container als fehlerhaft eingestuft wird
      retries: 5
      # Startzeitraum vor der ersten Integritätsprüfung
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
      # Verbindung zwischen Server und Reverse-Proxy.
      - proxy_network
      # Verbindung zwischen Server und Datenbank.
      - bomnipotent_network
    # Starten Sie den Container neu, wenn er aus einem anderen Grund als einem Benutzerbefehl angehalten wurde
    restart: always
    volumes:
      # Mounten Sie den Konfigurationsordner auf dem Host per Bind
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      # Die Subscription darf gern in dem Container persisitert werden
      - bomnipotent_subscription:/root/.config/bomnipotent
```
{{% /tab %}}
{{% tab title="not annotated" %}}
```yaml
name: bomnipotent_server_containers

networks:
  bomnipotent_network:
    driver: bridge
    name: bomnipotent_network
  proxy_network:
    driver: bridge
    name: proxy_network

volumes:
  bomnipotent_data:
    driver: local
  bomnipotent_subscription:
    driver: local

services:
  reverse_proxy:
    container_name: reverse_proxy
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    healthcheck:
      test: ["CMD-SHELL", "nginx -t || exit 1"]
      interval: 60s
      timeout: 10s
      retries: 3
      start_period: 60s
    image: nginx:latest
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - proxy_network
    ports:
      - "443:443"
    restart: on-failure
    volumes:
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true
      - type: bind
        source: ./proxy_config/conf.d
        target: /etc/nginx/conf.d
        read_only: true

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
    image: postgres:17
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
      SMTP_SECRET: ${SMTP_SECRET}
    healthcheck:
      test: ["CMD-SHELL", "curl --fail http://localhost:8080/health || exit 1"]
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
      - proxy_network
      - bomnipotent_network
    restart: always
    volumes:
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      - bomnipotent_subscription:/root/.config/bomnipotent
```
{{% /tab %}}
{{< /tabs >}}

Speichern Sie diese Datei als "compose.yaml". Dann rufen Sie:
{{< tabs >}}
{{% tab title="lang" %}}
```
docker compose up --detach
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
docker compose up -d
```
{{% /tab %}}
{{< /tabs >}}

Ihr Server ist jetzt einsatzbereit!

Rufen Sie "docker ps" um den Zustand des Servers zu überprüfen.
