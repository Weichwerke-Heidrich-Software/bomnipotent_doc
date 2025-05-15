+++
title = "SMTP Server"
slug = "smtp-server"
weight = 10
+++

## Direkte SMTP-Server-Kommunikation

Damit der BOMnipotent Server direkt mit Ihrem E-Mail-Server kommunizieren kann, richten Sie den [SMTP-Teil](/server/configuration/required/smtp/) Ihrer Konfigurationsdatei in etwa so ​​ein:
```toml
[smtp]
user = "you@yourdomain.com"
endpoint = "your.smtp.host"
secret = "${SMTP_SECRET}"
```
Die genaue Form hängt stark von Ihrem E-Mail-Anbieter ab. Manche Anbieter benötigen die vollständige E-Mail-Adresse als Benutzer, andere nicht.

Clients wie Mozilla Thunderbird können die erforderlichen Parameter in der Regel sehr gut ableiten. Falls Sie nicht weiterkommen, suchen Sie dort nach ihnen.

## Kommunikation über SMTP-Relay

Wenn Sie mehrere Dienste nutzen, die E-Mails versenden, kann es sinnvoll sein, lokal eine SMTP-Relay-Station zu betreiben. Sie bietet Ihrem Setup einen einzigen Endpunkt für die Kommunikation mit dem Mailserver.

Es gibt mehrere Docker-Container mit SMTP-Relay-Funktionalität. Dieses Tutorial konzentriert sich auf [crazymax/msmtpd](https://github.com/crazy-max/docker-msmtpd), da es unter den leichtgewichtigen Lösungen die beste Sicherheit bietet.

### Relay über Docker Compose ausführen

Fügen Sie den folgenden Dienst zu Ihrer compose.yaml Datei hinzu:
``` yaml
  smtp_relay:
    container_name: smtp_relay
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    environment:
      TZ: Europe/Berlin # Ersetzen Sie dies durch Ihre bevorzugte Zeitzone
      SMTP_HOST: your.smtp.host # Ersetzen Sie dies durch den korrekten Endpunkt
      SMTP_PORT: 465
      SMTP_TLS: on
      SMTP_STARTTLS: off
      SMTP_TLS_CHECKCERT: on
      SMTP_AUTH: login
      SMTP_USER: you@yourdomain.com # Ersetzen Sie dies durch Ihren Benutzernamen
      SMTP_FROM: you@yourdomain.com # Ersetzen Sie dies durch Ihre E-Mail-Adresse
      SMTP_PASSWORD: ${SMTP_PASSWORD}
      SMTP_DOMAIN: localhost
    healthcheck:
      test: ["CMD", "msmtp", "--version"]
      interval: 30s
      timeout: 10s
      retries: 3
    image: crazymax/msmtpd
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - smtp_network
    restart: unless-stopped
```

Dadurch wird der Container gestartet und verbindet sich mit Port 465 (dem Standard für das SMTPS-Protokoll) des SMTP-Hosts. Die Verschlüsselung erfolgt mit TLS und nicht mit STARTTLS. Der Server lauscht auf Port 2500. Dies ist zwar nicht aus der Eingabe ersichtlich, entspricht aber dem Standardverhalten von msmtp.

Die Änderung Ihrer Compose-Datei ist jedoch noch nicht abgeschlossen!

Unter „Netzwerke“ müssen Sie das SMTP-Netzwerk angeben:
``` YAML
  bomnipotent_server:
    container_name: bomnipotent_server
    depends_on:
      smtp_relay:
        condition: service_healthy
    ...
    networks:
      - smtp_network
```

Sie müssen das Netzwerk außerdem jedem Container hinzufügen, der es kontaktieren soll. Sie können diese Container auch vom SMTP-Relay abhängig machen, damit sie nicht gestartet werden, bevor die Relay Station bereit ist:
``` YAML
  bomnipotent_server:
    container_name: bomnipotent_server
    depends_on:
      smtp_relay:
        condition: service_healthy
    ...
    networks:
      - smtp_network
```

Neben den Änderungen an der Compose-Datei muss Ihre .env-Datei oder Ihre Umgebung das Geheimnis oder Passwort Ihres E-Mail-Anbieters enthalten:
{{< tabs >}}
{{% tab title=".env" %}}
```
SMTP_PASSWORD=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="bash" %}}
```
export SMTP_PASSWORD=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="cmd" %}}
```
set SMTP_PASSWORD=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="ps1" %}}
```
$env:SMTP_PASSWORD = "eHD5B6S8Kze3"
```
{{% /tab %}}
{{< /tabs >}}

In Ihrer BOMnipotent Server-Konfigurationsdatei können Sie nun den SMTP-Abschnitt so anpassen, dass die Verbindung zum Relay über das Docker-Netzwerk hergestellt wird:
``` toml
[smtp_config]
user = "you@yourdomain.com"
endpoint = "smtp://smtp_relay:2500"
```

### Relay im eigenständigen Docker-Container ausführen

Wenn Ihr Setup keine Compose-Datei enthält, können Sie den Container stattdessen direkt mit Docker ausführen. Stellen Sie sicher, dass Ihre Umgebung einen Wert für SMTP_PASSWORD bereitstellt, und führen Sie anschließend Folgendes aus:
```
docker run --detach -p 2500:2500 --name smtp_relay \
    -e TZ=Europe/Berlin \
    -e SMTP_HOST=your.smtp.host \
    -e SMTP_PORT=465 \
    -e SMTP_TLS=on \
    -e SMTP_STARTTLS=off \
    -e SMTP_TLS_CHECKCERT=on \
    -e SMTP_AUTH=login \
    -e SMTP_USER=you@yourdomain.com \
    -e SMTP_FROM=you@yourdomain.com \
    -e SMTP_PASSWORD=${SMTP_PASSWORD} \
    -e SMTP_DOMAIN=localhost \
    crazymax/msmtpd
```
Dies funktioniert im Wesentlichen wie der für die compose Datei vorgeschlagene Abschnitt. Ersetzen Sie erneut die Werte für TZ, SMTP_HOST, SMTP_USER und SMTP_FROM durch die Werte Ihres E-Mail-Anbieters.

Der obige Befehl stellt Port 2500 für localhost bereit. Ihre BOMnipotent-Konfiguration muss daher wie folgt lauten:
``` toml
[smtp_config]
user = "you@yourdomain.com"
endpoint = "smtp://localhost:2500"
```

Um den Container zu stoppen, führen Sie Folgendes aus:
```
docker stop smtp_relay
```
