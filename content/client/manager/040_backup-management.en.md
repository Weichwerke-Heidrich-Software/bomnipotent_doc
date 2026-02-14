+++
title = "Backup Management"
slug = "backup-management"
weight = 40
+++

Regularly backing up a database is an important step in any cyber resilience strategy. BOMnipotent's main mechanism for this is a [periodic backup task](/server/periodic-tasks/disabled/database-backup) that can and should be enabled in the configuration.

Apart from this automated process, BOMnipotent Client offers to manually create or restore a backup.

> For this to work, the [periodic backup task](/server/periodic-tasks/disabled/database-backup) needs to be configured, because the client interactions rely on its configuration parameters.

> [!IMPORTANT]
> The backup is created with the [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) tool, and restored with [dropdb](https://www.postgresql.org/docs/current/app-dropdb.html), [createdb](https://www.postgresql.org/docs/current/app-createdb.html) and [psql](https://www.postgresql.org/docs/current/app-psql.html). The [official BOMnipotent container](https://hub.docker.com/r/wwhsoft/bomnipotent_server) comes with these tools pre-installed, but if your setup is directly running the BOMnipotent Server binary you need to make sure that they are available on the system.

## Create

> Only users with the admin role can create backups.

You can manually trigger the creation of a backup outside of the schedule:

{{< example "database_backup_create" "1.4.0" >}}

The resulting file is stored to the directory configured for the [periodic backup task](/server/periodic-tasks/disabled/database-backup). This does not influence the schedule of the task.

## Completely Restore

> [!CAUTION]
> This command **completely replaces** the content of the current database with that of the latest backup.

> Only users with the admin role can restore backups.

If you need to reset your database to an earlier state, either because it has been corrupted or because you are recreating your server setup from scratch, you can use the "database-backup completely-restore" command:

{{< example "database_backup_restore" "1.4.0" >}}

> Due to the destructive nature of this command no short variant exists here.

This makes BOMnipotent Server **drop and recreate** the current database. It then applies the **latest backup file** it finds in the directory configured for the [periodic backup task](/server/periodic-tasks/disabled/database-backup). Make sure that this file indeed represents the state you want to recreate.

> Keep in mind that the periodic backup task is run once upon starting the server.
