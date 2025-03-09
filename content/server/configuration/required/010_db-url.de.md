+++
title = "Datenbank-URL"
slug = "db-url"
weight = 10
description = "Konfigurationsanleitung für die Datenbank-URL des BOMnipotent Servers, einschließlich Syntax und Beispiel."
+++

> Die "db_url"-Konfiguration **unterstützt kein** Hot Reloading. Sie müssen den Server nach einer Änderung neu starten.

BOMnipotent Server ist Ihr Gateway zur Bereitstellung von Daten zur Lieferkettensicherheit und zur Verwaltung des Zugriffs darauf. Die Daten selbst werden in einer SQL-Datenbank gespeichert.

> Derzeit wird nur [PostgreSQL](https://www.postgresql.org/) als Treiber unterstützt.

Diese Datenbank kann grundsätzlich in derselben Umgebung, in einem anderen Container oder auf einem Remote-Server ausgeführt werden. BOMnipotent muss beigebracht werden, wie es sie erreicht. Der Parameter zum Bereitstellen dieser Informationen in der Konfigurationsdatei ist "db_url", und die Syntax ist die folgende:
```toml
db_url = "<Treiber>://<Benutzer>:<Passwort>@<Domäne>:<Port>/<Datenbank>"
```
BOMnipotent wird sauer auf Sie sein, wenn die von Ihnen angegebene Zeichenfolge nicht diesem Format entspricht.

Ein tatsächlicher Eintrag könnte beispielsweise lauten:
```toml
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
```
Lassen Sie uns das aufschlüsseln:
- Der Treiber ist "postgres", der einzige Treiber, welcher derzeit unterstützt wird.
- Der Benutzername lautet "bomnipotent_user", da dies der Wert ist, der PostgreSQL während der Einrichtung bereitgestellt wurde.
- Das Passwort wird aus der externen Variable "BOMNIPOTENT_DB_PW" gelesen, die über die Umgebung oder eine .env-Datei bereitgestellt werden kann. Sie könnten es auch direkt in der Konfigurationsdatei speichern, aber das gilt als schlechte Praxis.
- Die Domäne lautet "bomnipotent_db", das ist der Name des Docker-Containers, welcher die Datenbank ausführt. Für eine Datenbank in derselben Umgebung wäre dies stattdessen "localhost", und für eine externe Datenbank wäre es eine andere Domäne oder IP-Adresse.
- Der Port ist 5432, der Standardport, auf den PostgreSQL lauscht. In diesem Fall befindet sich der Docker-Container im selben Docker-Netzwerk wie der BOMnipotent-Server Container. Ohne diese direkte Verbindung müssten Sie diesen internen Port im Docker-Setup einem beliebigen externen Port zuordnen und diesen externen Port in der Konfiguration angeben.
- Die Datenbank selbst wird auch "bomnipotent_db" genannt, da dies der Wert ist, der PostgreSQL während des Setups bereitgestellt wurde.

Wenn der BOMnipotent-Server die Datenbank nicht erreichen kann, werden Sie in den Logs darüber informiert.
