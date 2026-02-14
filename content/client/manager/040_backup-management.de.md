+++
title = "Sicherungsverwaltung"
slug = "backup-management"
weight = 40
description = "Sicherungsverwaltung für BOMnipotent: Manuelles Erstellen und Wiederherstellen von Datenbank-Backups."
+++

Eine Datenbank regelmäßig zu sichern ist ein wichtiger Schritt in jeder Cyber-Resilienz-Strategie. BOMnipotents hauptsächlicher Mechanismus um dies zu tun ist eine [zyklische Sicherungsaufgabe](/de/server/periodic-tasks/disabled/database-backup), welche in der Konfiguration aktiviert werden kann.

Abgesehen von diesem automatisierten Prozess bietet BOMnipotent Client die Möglichkeiten, eine Sicherung manuell zu erstellen oder wiederherzustellen.

> Damit dies funktioniert muss die [zyklische Sicherungsaufgabe](/de/server/periodic-tasks/disabled/database-backup) konfiguriert sein, da die Interaktion mit dem Client auf deren Parametern aufbaut.

> [!IMPORTANT]
> Die Sicherung wird mit dem [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) erstellt, und mit [dropdb](https://www.postgresql.org/docs/current/app-dropdb.html), [createdb](https://www.postgresql.org/docs/current/app-createdb.html) und [psql](https://www.postgresql.org/docs/current/app-psql.html) wiederhergestellt. Der [offizielle BOMnipotent Container](https://hub.docker.com/r/wwhsoft/bomnipotent_server) hat diese Tools vorinstalliert, aber falls Ihr Setup direkt die BOMnipotent Server Binary verwendet müssen Sie sicherstellen, dass sie auf dem System verfügbar sind.

## Erstellen

> Nur Nutzer mit der Administrator Rolle können Sicherungen erstellen.

Sie können das Erstellen einer Sicherung außerhalb des üblichen Zeitplans manuell auslösen:

{{< example "database_backup_create" "1.4.0" >}}

Die resultierende Datei wird in dem Ordner gespeichert, welcher für die [zyklische Sicherungsaufgabe](/de/server/periodic-tasks/disabled/database-backup) konfiguriert ist. Der Zeitplan wird hierdurch nicht beeinflusst.

## Vollständige Wiederherstellung

> [!CAUTION]
> Dieser Befehl **ersetzt** den aktuellen Inhalt der Datenbank **komplett** mit dem der letzten Sicherung.

> Nur Nutzer mit der Administrator Rolle können Sicherungen wiederherstellen.

Falls Sie Ihre Datenbank auf einen früheren Zustand zurücksetzen müssen, entweder weil sie korrumpiert wurde oder weil Sie Ihre Server Setup komplett neu aufsetzen, dann können Sie dazu den "database-backup completely-restore" Befehl nutzen:

{{< example "database_backup_restore" "1.4.0" >}}

> Aufgrund der destruktiven Natur dieses Befehls existiert hier keine kurze Variante.

Dies bringt BOMnipotent Server dazu, die aktuelle Datenbank **wegzuwerfen und neu zu erstellen**. Danach wendet er die **letzte Sicherungsdatei** an, die er im Ordner findet, welcher für die [zyklische Sicherungsaufgabe](/de/server/periodic-tasks/disabled/database-backup) konfiguriert ist. Gehen Sie sicher, dass diese Datei tatsächlich den Zustand repräsentiert, den Sie wiederherstellen möchten.

> Beachten Sie, dass die zyklische Sicherungsaufgabe einmal beim Serverstart ausgeführt wird.
