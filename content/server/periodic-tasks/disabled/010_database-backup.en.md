+++
title = "Database Backup"
slug = "database-backup"
weight = 10
+++

This task creates a full backup of the database and stores it to an SQL file.

The name of this task is "database_backup", and it accepts the following [configurations](/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "database_backup"
directory = "/etc/bomnipotent_server/backups/"
period = "1 day" # Optional
enabled = true # Optional
```

> [!IMPORTANT]
> The backup is created with the [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) tool, and restored with [dropdb](https://www.postgresql.org/docs/current/app-dropdb.html), [createdb](https://www.postgresql.org/docs/current/app-createdb.html) and [psql](https://www.postgresql.org/docs/current/app-psql.html). The [official BOMnipotent container](https://hub.docker.com/r/wwhsoft/bomnipotent_server) comes with these tools pre-installed, but if your setup is directly running the BOMnipotent Server binary you need to make sure that they are available on the system.

The filename of the backup contains the name of the database and a timestamp. It is stored in the configured directory.

The directory refers to a path on the filesystem visible to BOMnipotent Server. For the recommended setup with a Docker compose file, this means that the backup is only stored *inside* the container. To synchronise the backup with the host system, you can add a bind-mount volume to your Docker compose file. For example:
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
        read_only: false # BOMnipotent requires write access in this case.
```
From there you can synchronise the backups with your backup server.

To restore a backup you can use the ["database-backup completely-restore"](/client/manager/backup-management/#completely-restore) command of BOMnipotent Client.
