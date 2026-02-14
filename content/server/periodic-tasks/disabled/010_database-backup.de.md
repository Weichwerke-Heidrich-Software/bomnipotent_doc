+++
title = "Datenbanksicherung"
slug = "database-backup"
weight = 10
description = "Erstellen Sie eine vollständige Sicherung ihrer BOMnipotent Datenbank um sie zu einem späteren Zeitpunkt wiederherstellen zu können."
+++

Diese Aufgabe erstellt eine vollständige Sicherung der Datenbank und speichert sie als SQL Datei.

Der Name dieser Aufgabe lautet "database_backup". Sie akzeptiert die folgenden [Konfigurationen](/de/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "database_backup"
directory = "/etc/bomnipotent_server/backups/"
period = "1 day" # Optional
enabled = true # Optional
```

> [!IMPORTANT]
> Die Sicherung wird mit dem [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) erstellt, und mit [dropdb](https://www.postgresql.org/docs/current/app-dropdb.html), [createdb](https://www.postgresql.org/docs/current/app-createdb.html) und [psql](https://www.postgresql.org/docs/current/app-psql.html) wiederhergestellt. Der [offizielle BOMnipotent Container](https://hub.docker.com/r/wwhsoft/bomnipotent_server) hat diese Tools vorinstalliert, aber falls Ihr Setup direkt die BOMnipotent Server Binary verwendet müssen Sie sicherstellen, dass sie auf dem System verfügbar sind.

Der Dateiname der Sicherung enthält den Namen der Datenbank sowie einen Zeitstempel. Sie wird in den konfigurierten Ordner gespeichert.

Der Ordner bezieht sich auf einen Pfad auf dem Dateisystem, welches BOMnipotent Server sieht. Für das empfohlene Setup mit einer Docker compose Datei bedeutet dies, dass die Sicherung nur *innerhalb* des Containers gespeichert wird. Um die Sicherung auch mit dem Host System zu synchronisieren können Sie ein Bind-Mount Volumen in Ihrer Docker compose Datei hinzufügen. Beispielsweise:
```yaml
# ...
services:
  # ...
  bomnipotent_server:
    # ...
    volumes:
      # ...
      - type: bind
        source: ./backups/bomnipotent_db
        target: /etc/bomnipotent_server/backups/
        read_only: false # BOMnipotent benötigt in diesem Fall Schreibrechte.
```
Von dort können Sie die Sicherung mit Ihrem Sicherungsserver synchronisieren.

Um eine Sicherung wiederherzustellen können Sie den ["database-backup completely-restore"](/de/client/manager/backup-management/#completely-restore) Befehl von BOMnipotent Client verwenden.
