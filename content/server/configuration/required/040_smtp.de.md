+++
title = "SMTP-Einstellungen"
slug = "smtp"
weight = 40
+++

Simple Mail Transfer Protocol (SMTP) ist das Protokoll zum Versenden von E-Mails. Im Kontext von BOMnipotent verwendet der Server es, um zu überprüfen, ob neu angefragte Benutzer Zugriff auf die von ihnen angegebene E-Mail-Adresse haben. Dazu muss der Server einen SMTP-Endpunkt erreichen.

## SMTP konfigurieren

Der SMTP-Abschnitt der Konfigurationsdatei sieht folgendermaßen aus:
```toml
[smtp]
user = "you@yourdomain.com"
endpoint = "your.smtp.host"
secret = "${SMTP_SECRET}" # Optional
starttls = true # Optional, standardmäßig false
```

### Eingaben

#### User / Benutzer

Der SMTP-Benutzer ist die E-Mail-Adresse, die Sie zur Authentifizierung bei Ihrem Mailserver verwenden.

#### Endpunkt

Der SMTP-Endpunkt teilt BOMnipotent mit, wohin die Daten gesendet werden sollen. Er kann direkt auf Ihren Mailserver oder auf ein SMTP-Relay verweisen.

Beginnt der Endpunkt mit dem Marker "smtp://", versucht BOMnipotent Server, eine direkte Verbindung zu dieser URL herzustellen. Dies ist typischerweise bei der Verbindung mit einem lokal laufenden Relay erwünscht. Andernfalls wird eine Verbindung zu einem externen Relay hergestellt.

#### Geheimnis

Bei der direkten Kommunikation mit Ihrem Mailserver müssen Sie sich authentifizieren. Das Geheimnis ist entweder Ihr Passwort oder ein API-Schlüssel, falls Ihr Mail-Provider einen anbietet. Im obigen Beispiel wird das Geheimnis aus der Umgebungsvariable "SMTP_SECRET" gelesen, die zum Beispiel aus einer .env-Datei stammen kann.

Ein lokal laufendes SMTP-Relay benötigt nicht unbedingt ein Passwort zum Empfangen von E-Mails, daher ist dieses Feld optional.

#### STARTTLS

STARTTLS ist eine Möglichkeit, E-Mails zu verschlüsseln, die andere ist SMTPS. Seit 2018 rät die Internet Engineering Task Force [von der Verwendung von STARTTLS ab](https://datatracker.ietf.org/doc/html/rfc8314). Sollte Ihr Mailserver jedoch kein SMTPS unterstützen, ist STARTTLS besser als gar keine Verschlüsselung. Daher wird es von BOMnipotent Server weiterhin unterstützt.

## Benutzerverifizierung überspringen

Wenn Sie (noch) keinen Zugriff auf einen SMTP-Server haben, können Sie die SMTP-Konfiguration umgehen, indem Sie die folgende Zeile im globalen Kontext (also am Anfang) Ihrer config.toml hinzufügen:

```toml
skip_user_verification = true
```

Der BOMnipotent Server sendet dann *keine* Verifizierungs-E-Mail an neu angemeldete Benutzer. Stattdessen wird jedes Mal eine Warnmeldung ausgegeben, wenn die E-Mail *nicht* versendet wird, da diese Konfiguration die Sicherheit Ihres Servers beeinträchtigt.