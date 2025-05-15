+++
title = "Freistehend"
slug = "standalone"
weight = 30
description = "Anleitung zur Einrichtung des BOMnipotent Servers als eigenständige Anwendung unter Linux und Windows, inklusive PostgreSQL- und Konfigurationsdetails."
+++

Sie sind nicht gezwungen den offiziellen BOMnipotent Server [Docker-Container](https://hub.docker.com/r/wwhsoft/bomnipotent_server) zu verwenden. Stattdessen können Sie die BOMnipotent Server-Binärdatei herunterladen und direkt als eigenständige Anwendung ausführen.

> Dieses Setup ist erst ab Version 0.4.2 sinnvoll, da der Server zuvor keine Portanpassungen und keine Protokollierung in Dateien unterstützte.

## Voraussetzung: PostgreSQL

Der BOMnipotent Server benötigt eine PostgreSQL-Datenbank zur Datenspeicherung. Die Einrichtung hängt von Ihrem Server-Betriebssystem ab.

{{< tabs >}}
{{% tab title="Linux" %}}
Auf den gängigsten Distributionen wird PostgreSQL als Paket angeboten. Sie können es beispielsweise über apt/apt-get/aptitude installieren:
```
sudo apt-get install postgresql postgresql-contrib
```
PostgreSQL läuft nun als Dienst. Um weitere Anpassungen vorzunehmen, müssen Sie sich als Systembenutzer "postgres" anmelden:
```
sudo -i -u postgres
```
Sie können nun die interaktive PostgreSQL-Shell öffnen:
```
psql
```
In der Shell müssen Sie den Benutzer "bomnipotent_user" und ein Passwort hinzufügen und die Datenbank "bomnipotent_db" erstellen:
``` sql
CREATE USER bomnipotent_user WITH PASSWORD 'Ihr Passwort';
CREATE DATABASE bomnipotent_db OWNER bomnipotent_user;
GRANT ALL PRIVILEGES ON DATABASE bomnipotent_db TO bomnipotent_user;
\q
```
> Sie können andere Namen für Benutzer und Datenbank verwenden, müssen dann aber den Eintrag "db_url" in Ihrer [Konfigurationsdatei](#configtoml) entsprechend anpassen.

Starten Sie PostgreSQL anschließend neu und wechseln Sie zurück zu Ihrem regulären Benutzer:
```
sudo systemctl restart postgresql;
exit
```

{{% /tab %}}
{{% tab title="Windows" %}}
Für Windows bietet PostgreSQL ein [interaktives Installationsprogramm](https://www.postgresql.org/download/windows/) an.

Nach Abschluss des Installationsvorgangs wird PostgreSQL als Dienst ausgeführt. Öffnen Sie eine interaktive PostgreSQL-Shell, indem Sie die Administrationskonsole starten und Folgendes eingeben:
```
psql -U postgres
```
In der Shell müssen Sie den Benutzer "bomnipotent_user" hinzufügen, ein Passwort vergeben und die Datenbank "bomnipotent_db" erstellen:
``` sql
CREATE USER bomnipotent_user WITH PASSWORD 'Ihr Passwort';
CREATE DATABASE bomnipotent_db OWNER bomnipotent_user;
GRANT ALL PRIVILEGES ON DATABASE bomnipotent_db TO bomnipotent_user;
\q
```
> Sie können andere Namen für Benutzer und Datenbank verwenden, müssen dann aber den Eintrag "db_url" in Ihrer [Konfigurationsdatei](#configtoml) entsprechend anpassen.
{{% /tab %}}
{{% tab title="Docker" %}}
Wenn Sie nur BOMnipotent Server als eigenständige Anwendung ausführen, aber dennoch PostgreSQL in einem Container laufen lassen möchten, können Sie letzteren wie folgt starten:
```
docker run --name bomnipotent_db \
  -e POSTGRES_DB=bomnipotent_db \
  -e POSTGRES_USER=bomnipotent_user \
  -e POSTGRES_PASSWORD=<your-password> \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  -d postgres:latest
```
Dadurch wird ein Container namens "bomnipotent_db" mit der ebenso benannten Datenbank "bomnipotent_db", dem Benutzer "bomnipotent_user" und einem Passwort erstellt. Der Befehl stellt Port 5432 des Containers bereit, speichert die Daten in einem Docker-Volume und startet das Image "postgres:latest" im losgelösten Modus.

> Sie können andere Namen für Benutzer und Datenbank verwenden, müssen dann aber den Eintrag "db_url" in Ihrer [Konfigurationsdatei](#configtoml) entsprechend anpassen.

{{% /tab %}}
{{< /tabs >}}

## Empfohlene Dateistruktur

Die vorgeschlagene Dateistruktur im Lieblingsverzeichnis Ihres Servers sieht folgendermaßen aus:
```
├── bomnipotent_config
│   ├── .env
│   ├── config.toml
│   └── config.toml.default
└── bomnipotent_server
```

Diese Anleitung führt Sie durch die einzelnen Dateien und erklärt sie Schritt für Schritt.

## .env

Der BOMnipotent-Server kommuniziert mit einer Datenbank. Derzeit wird nur [PostgreSQL](https://www.postgresql.org/) als Backend unterstützt. Die Datenbank ist durch ein Passwort geschützt. Es empfiehlt sich, das Passwort in einer separaten .env-Datei zu speichern, anstatt direkt im compose.yaml.

> Der Name der Datei muss ".env" lauten, ansonsten erkennt BOMnipotent Server sie nicht.

Ihre .env-Datei sollte so aussehen:
```
BOMNIPOTENT_DB_PW=<Ihr-Datenbank-Passwort>
SMTP_SECRET=<Ihr-smtp-Authentifizierungs-Geheimnis>
```

Falls Sie ein Versionierungssystem zum Speichern Ihres Setups verwenden, vergessen Sie nicht, ".env" zu Ihrer .gitignore oder analogen Ignore-Datei hinzuzufügen!

## config.toml

BOMnipotent Server benötigt eine Konfigurationsdatei, die in [einem anderen Abschnitt](/de/server/configuration/config-file/) ausführlicher erläutert wird.

> Der Name der Datei ist beliebig.

Eine minimale Konfiguration sieht folgendermaßen aus:
```toml {wrap="false" title="config.toml"}
# Die Datenbank-URL hat die Struktur [db_client]://[Benutzer]:[Passwort]@[Adresse]:[Port]/[db]
# Beachten Sie, dass ${BOMNIPOTENT_DB_PW} auf eine Umgebungsvariable verweist.
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@localhost:5432/bomnipotent_db"
# Domain, hinter der der bomnipotent-Server gehostet wird
domain = "https://bomnipotent.<Ihre-Domain>.<Top-Level>"
# An den typischen Port für HTTPS binden
https_port = 443

[log]
# Server anweisen, in eine Datei statt in die Standardausgabe zu protokollieren
file = "/var/log/bomnipotent.log"

[tls]
# Pfad zu Ihrer vollständigen TLS-Zertifikatskette
certificate_chain_path = "/etc/ssl/certs/<Ihre-TLS-Zertifikatskette.crt>"
# Pfad zu Ihrem geheimen TLS-Schlüssel
secret_key_path = "/etc/ssl/private/<Ihr-geheimer-TLS-Schlüssel>"

[smtp]
# Der Nutzername für den Mail-Anbieter, üblicherweise Ihre Mail Adresse
user = "<you@yourdomain.com>"
# Der SMTP Endpunkt Ihres Mail-Anbieters
endpoint = "<your.smtp.host>"
# Das Geheimnis um sich gegenüber dem Mail-Anbieter zu authentifizierenn, üblicherweise Ihr Passwort
secret = "${SMTP_SECRET}"

# Herausgeberdaten gemäß CSAF-Standard (Link unten)
[provider_metadata.publisher]
name = "<Name Ihrer Organisation>"
# Namespace Ihrer Organisation in Form einer vollständigen URL
namespace = "https://<Ihre Domain>.<Top-Level>"
# Dies ist höchstwahrscheinlich die gewünschte Enumerationsvariante.
category = "Anbieter"
# Kontaktdaten sind optional und frei wählbar.
contact_details = "<Bei Sicherheitsanfragen kontaktieren Sie uns bitte unter...>"
```
Fügen Sie Ihre Daten in die Klammern ein.

> Der [Abschnitt zur TLS-Konfiguration](/de/server/configuration/required/tls-config/) enthält ausführlichere Informationen, um häufige Fehler zu vermeiden.

Falls Sie es bevorzugen, eine lokal laufende SMTP Relay Station zu nutzen, schauen Sie sich die [notwendigen Anpassungen](/de/integration/smtp-server/#kommunikation-über-smtp-relay) der compose Datei an.

Die Publisher-Daten werden verwendet, um den [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3218-document-property---publisher) einzuhalten.

> Der [Abschnitt über Provider-Metadaten](/de/server/configuration/required/provider-metadata/) beschreibt die Bedeutung der Felder im Detail.

Es wird empfohlen, die Datei config.toml in einem dedizierten Verzeichnis (in diesem Beispiel "bomnipotent_config") zu speichern. BOMnipotent Server überwacht das Verzeichnis auf Änderungen. Je weniger Dateien sich im Ordner befinden, desto weniger muss er überwachen. Der Server versucht, die Konfigurationsdatei und die .env-Datei neu zu laden, sobald sich eine davon ändert.

> Viele Konfigurationseinstellungen unterstützen Hot Reloading, d. h. sie können ohne Serverneustart geändert werden.

Nachdem Sie Ihre config.toml eingerichtet haben, können Sie diese beispielsweise als config.toml.default kopieren, um Ihre ursprüngliche Konfiguration schnell wiederherstellen zu können. Dies ist jedoch völlig optional.

## bomnipotent_server

Dies ist die Binärdatei, mit der BOMnipotent Server ausgeführt wird. Sie können jede Version für Ihre Serverplattform von [www.bomnipotent.de](https://www.bomnipotent.de/de/downloads/) herunterladen.

Grundsätzlich benötigt BOMnipotent Server lediglich den Pfad zu seiner Konfigurationsdatei. Wenn Sie die Binärdatei ausführen und den Pfad als erstes Argument angeben, haben Sie eine funktionierende Serverinstanz erstellt. Ihr Terminal ist nun jedoch dauerhaft blockiert, und der Dienst wird nach einem Systemneustart nicht neu gestartet. Der Rest dieses Abschnitts dient lediglich dazu, sicherzustellen, dass das Betriebssystem den Server ordentlich unterstützt.

> Im Gegensatz BOMnipotent Client, der unter allen gängigen Betriebssystemen läuft, wird BOMnipotent Server derzeit nur unter Linux und Windows unterstützt. Wenn Sie ihn auf einem Server mit macOS hosten möchten, [erstellen Sie bitte einen Issue](https://github.com/Weichwerke-Heidrich-Software/bomnipotent_doc/issues).

{{< tabs >}}
{{% tab title="Linux" %}}
> Für diese Konfiguration muss systemd auf Ihrer Distribution integriert sein.
>
> Falls Sie unsicher sind, ob es das ist, ist es das wahrscheinlich.
>
> Falls Sie sicher sind, dass es das nicht ist, benötigen Sie diese Anleitung wahrscheinlich nicht.

Erstellen Sie die Datei "/etc/systemd/system/bomnipotent.service" mit folgendem Inhalt:
``` php
[Unit]
Description=BOMnipotent Server
After=network.target

[Service]
ExecStart=/path/to/bomnipotent_server /path/to/bomnipotent_config/config.toml
WorkingDirectory=/path/to/bomnipotent_config
Restart=on-failure
User=<IhrBenutzer>

[Install]
WantedBy=multi-user.target
```
Passen Sie die Werte an Ihren Server an. Führen Sie anschließend Folgendes aus:
```
sudo systemctl daemon-reexec
sudo systemctl enable --now bomnipotent.service
```

{{% /tab %}}
{{% tab title="Windows" %}}
Öffnen Sie die Aufgabenplanung (taskschd.msc).

Klicken Sie im rechten Bereich auf "Aufgabe erstellen".

Im Reiter "Allgemein":
- Benennen Sie die Aufgabe "BOMnipotent Server".
- Wählen Sie "Ausführen, unabhängig davon, ob der Benutzer angemeldet ist oder nicht".

Im Reiter "Trigger":
- Klicken Sie auf "Neu" und wählen Sie "Beim Start".

Im Reiter "Aktionen":
- Klicken Sie auf "Neu" und legen Sie die Aktion auf "Programm starten" fest.
- Wählen Sie unter "Programm/Skript" "C:\Pfad\zu\bomnipotent_server.exe" (entsprechend anpassen).
- Geben Sie unter "Argumente hinzufügen (optional)" "C:\Pfad\zu\bomnipotent_config\config.toml" ein (entsprechend anpassen).

Klicken Sie auf "OK", um die Aufgabe zu speichern.
{{% /tab %}}
{{< /tabs >}}
