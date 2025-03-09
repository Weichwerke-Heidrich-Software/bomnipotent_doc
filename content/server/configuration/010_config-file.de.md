+++
title = "Die Konfigurationsdatei"
slug = "config-file"
weight = 10
description = "Konfigurieren Sie BOMnipotent Server mit einer TOML-Datei. Erfahren Sie, wie Hot Reloading und Umgebungsvariablen die Konfiguration erleichtern."
+++

Ihre Instanz von BOMnipotent Server wird mithilfe einer Konfigurationsdatei konfiguriert. Sie enthält mehrere Werte, die im [TOML-Format](https://toml.io/en/) übergeben werden. Die [Anleitungen zum Starten des Servers](/de/server/setup/starting/) enthalten jeweils eine Konfigurationsdatei, die Sie mit Ihren spezifischen Daten füllen können. Alle von BOMnipotent Server akzeptierten Konfigurationen werden im [Rest dieses Abschnitts](/de/server/configuration/) beschrieben.

## (Neu-)Laden von Konfigurationen

Viele Konfigurationen unterstützen Hot Reloading. Dies bedeutet, dass Sie sie innerhalb der Datei ändern können und sie wirksam werden, ohne dass ein Neustart des Servers erforderlich ist. BOMnipotent Server erreicht dies, indem es auf Dateiänderungen in dem Verzeichnis lauscht, in dem sich die Konfigurationsdatei befindet. Sie können ein erfolgreiches Neuladen der Konfigurationen überprüfen, indem Sie sich die Protokolle ansehen:
```bash
docker logs bomnipotent_server -n 1
```
``` {wrap="false" title="output"}
2025-03-06 15:34:45 +00:00 [INFO] Configuration successfully reloaded from "/etc/bomnipotent_server/configs/config.toml"
```
Wenn etwas nicht wie vorgesehen funktioniert, informiert BOMnipotent Sie ebenfalls in den Protokollen darüber:
```bash
docker logs bomnipotent_server -n 6
```
``` {wrap="false" title="output"}
2025-03-06 16:11:03 +00:00 [ERROR] Failed to read config file "/etc/bomnipotent_server/configs/config.toml": Failed to parse config file: TOML parse error at line 5, column 1
  |
5 | starlight_throughput = "16 GW"
  | ^^^^^^^^^^^^^^^^^^^^
unknown field `starlight_throughput`, expected one of `allow_http`, `allow_tlp2`, `certificate_chain_path`, `db_url`, `default_tlp`, `domain`, `dos_prevention_limit`, `dos_prevention_period`, `log_level`, `provider_metadata_path`, `publisher_data`, `secret_key_path`, `tmp_admin`, `user_expiration_period`
```

> Wenn beim Laden der Konfiguration während des Serverstarts ein Fehler auftritt, wird der Vorgang abgebrochen. Wenn die Konfiguration für einen bereits laufenden Server nicht neu geladen werden kann, bleibt die letzte gültige Konfiguration unverändert.

Das offizielle [BOMnipotent Server-Docker-Image](https://hub.docker.com/r/wwhsoft/bomnipotent_server) sucht im Container unter dem Pfad "/etc/bomnipotent_server/configs/config.toml" nach der Konfigurationsdatei. Es wird empfohlen, den Containerpfad "/etc/bomnipotent_server/configs/" mit nur Leserechten an ein Verzeichnis Ihrer Wahl auf dem Hostcomputer zu binden.

> **Wichtig:** Damit das Hot Reloading funktioniert, muss Ihr Docker Volume an das **Verzeichnis** gebunden sein, in dem sich die Konfigurationsdatei befindet, **nicht an die Datei selbst**. Bei einer direkten Dateibindung empfängt BOMnipotent keine Dateiereignisse und kann die Konfiguration daher bei Änderungen nicht neu laden.

## Umgebungsvariablen

In Ihren Konfigurationsdateien können Sie auf Umgebungsvariablen verweisen. Verwenden Sie dazu einfach `${<irgendeine-Umbgeunsvariable>}` irgendwo in der Datei, wobei "\<irgendeine-Umbgeunsvariable\>" durch den Namen der Variable ersetzt wird.

Wenn Sie beispielsweise Folgendes angeben:
{{< tabs >}}
{{% tab title=".env" %}}
```bash
BOMNIPOTENT_DB_PW=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="bash" %}}
```bash
export BOMNIPOTENT_DB_PW=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="cmd" %}}
```bash
set BOMNIPOTENT_DB_PW=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="ps1" %}}
```bash
$env:BOMNIPOTENT_DB_PW = "eHD5B6S8Kze3"
```
{{% /tab %}}
{{% tab title="docker" %}}
```bash
docker run -e BOMNIPOTENT_DB_PW=eHD5B6S8Kze3 wwhsoft/bomnipotent_server --detach
```
{{% /tab %}}
{{< /tabs >}}
dann können Sie es in Ihrer config.toml wie folgt verwenden:
```toml
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
```

> Sie würden dieses öffentlich verfügbare Beispielpasswort doch nicht wirklich verwenden, oder?

BOMnipotent Server unterstützt das Lesen von Variablen aus einer .env Datei. Wenn sich eine Datei mit genau diesem Namen, ".env", neben Ihrer Konfigurationsdatei befindet, versucht der Server, sie auszuwerten, bevor die Konfiguration geladen wird.

Das Ändern der .env-Datei während der Ausführung des BOMnipotent-Servers löst ein Hot Reloading und eine Neuauswertung sowohl der .env- als auch der Konfigurationsdatei aus.
