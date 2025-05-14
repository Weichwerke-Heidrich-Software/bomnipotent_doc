+++
title = "Standalone"
slug = "standalone"
weight = 30
description = "Learn how to set up and run the BOMnipotent Server as a standalone application on Linux or Windows, with PostgreSQL and configuration details."
+++

You are not required to run the official BOMnipotent Server [docker container](https://hub.docker.com/r/wwhsoft/bomnipotent_server). Instead, you can download and directly run the BOMnipotent Server binary as a standalone application.

> This setup only really makes sense for version 0.4.2 onwards, because the server did not offer port adjustments and logging to files before that.

## Prerequisite: PostgreSQL

BOMnipotent Server requires a PostgreSQL database for storing its data. The setup depends on your server operating system.

{{< tabs >}}
{{% tab title="Linux" %}}
On the most common distributions, PostgreSQL is offered as a package. You can install it via for example apt/apt-get/aptitude:
```
sudo apt-get install postgresql postgresql-contrib
```
Now PostgeSQL is running as a service. To further modify it, you need to become the postgres system user:
```
sudo -i -u postgres
```
Now you can open the interactive PostgreSQL shell:
```
psql
```
Inside the shell, you need to add the user "bomnipotent_user", a password, and create a database "bomnipotent_db":
``` sql
CREATE USER bomnipotent_user WITH PASSWORD 'your-password';
CREATE DATABASE bomnipotent_db OWNER bomnipotent_user;
GRANT ALL PRIVILEGES ON DATABASE bomnipotent_db TO bomnipotent_user;
\q
```
> You could use different names for the user and database, but would need to adjust the "db_url" entry of your [config file](#configtoml) accordingly.

Finally, restart PostgreSQL and switch back to your regular user:
```
sudo systemctl restart postgresql;
exit
```

{{% /tab %}}
{{% tab title="Windows" %}}
For Windows, PostgreSQL offers an [interactive installer](https://www.postgresql.org/download/windows/).

After it has completed, PostgeSQL is running as a service. Open an interactive PostgreSQL shell by starting an admin console and prompting:
```
psql -U postgres
```
Inside the shell, you need to add the user "bomnipotent_user", a password, and create a database "bomnipotent_db":
``` sql
CREATE USER bomnipotent_user WITH PASSWORD 'your-password';
CREATE DATABASE bomnipotent_db OWNER bomnipotent_user;
GRANT ALL PRIVILEGES ON DATABASE bomnipotent_db TO bomnipotent_user;
\q
```
> You could use different names for the user and database, but would need to adjust the "db_url" entry of your [config file](#configtoml) accordingly.
{{% /tab %}}
{{% tab title="Docker" %}}
If you only want to run BOMnipotent Server as a standalone application, but still want to containerise PostgreSQL, you can spin it up via:
```
docker run --name bomnipotent_db \
  -e POSTGRES_DB=bomnipotent_db \
  -e POSTGRES_USER=bomnipotent_user \
  -e POSTGRES_PASSWORD=<your-password> \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  -d postgres:latest
```
This creates a container named "bomnipotent_db", with a database also called "bomnipotent_db", a user called "bomnipotent_user", and a password that you need to set. It exposes port 5432 of the container, persists the data in a docker volume, and spins up the "postgres:latest" image in detached mode.

> You could use different names for the user and database, but would need to adjust the "db_url" entry of your [config file](#configtoml) accordingly.
{{% /tab %}}
{{< /tabs >}}

## Suggested File Structure

The suggested file structure in the favourite directory of your server looks like this:
```
├── bomnipotent_config
│   ├── .env
│   ├── config.toml
│   └── config.toml.default
└── bomnipotent_server
```

This tutorial will walk through the files and explain them one by one.

## .env

BOMnipotent server communicates with a database. Currently, only [PostgreSQL](https://www.postgresql.org/) is supported as a backend. The database is protected by a password. It is best practice to store the password inside a separate .env file instead of directly in the compose.yaml.

> The name of the file must be ".env", otherwise BOMnipotent Server will not recognise it.

Your .env file should look like this:
```
BOMNIPOTENT_DB_PW=<your-database-password>
```

If you are using a versioning system to store your setup, do not forget to add ".env" to your .gitignore or analogous ignore file!

> To put the security into perspective: The compose file will **not** directly expose the PostgreSQL container to the internet. The password is therefore only used for calls within the container network.

## config.toml

BOMnipotent Server needs a configuration file, which is explained in more detail in [another section](/server/configuration/config-file/).

> The name of the file is arbitrary.

A minimal configuration looks like this:
```toml {wrap="false" title="config.toml"}
# The db_url has the structure [db_client]://[user]:[password]@[address]:[port]/[db]
# Note that ${BOMNIPOTENT_DB_PW} references an environment variable.
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@localhost:5432/bomnipotent_db"
# Domain behind which bomnipotent server will be hosted
domain = "https://bomnipotent.<your-domain>.<top-level>"
# Bind to the typical port used for HTTPS
https_port = 443

[log]
# Tell the server to log to a file instead of to stdout
file = "/var/log/bomnipotent.log"

[tls]
# The path to your full TLS certificate chain
certificate_chain_path = "/etc/ssl/certs/<your-TLS-certificate-chain.crt>"
# The path to your secret TLS key
secret_key_path = "/etc/ssl/private/<your-secret-TLS-key>"

# Publisher data according to the CSAF Standard linked below
[provider_metadata.publisher]
name = "<Provide the name of your organsiation>"
# Namespace of your organisation, in form of a complete URL
namespace = "https://<your-domain>.<top-level>"
# This is most likely the enum variant you want
category = "vendor"
# Contact details are optional and in free form
contact_details = "<For security inquiries, please contact us at...>"

[smtp]
TODO
```
Fill in the braces with your data.

> The [section about TLS configuration](/server/configuration/required/tls-config/) contains more detailed information to avoid common pitfalls.

The publisher data is used to comply with the [OASIS CSAF standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3218-document-property---publisher).

> The [section about provider-metadata](/server/configuration/required/provider-metadata/) goes into more details what the fields actually mean.

It is recommended to store your config.toml file inside a dedicated directory, "bomnipotent_config" in this example. BOMnipotent Server will watch the directory for any changes, meaning that it has less to watch the less files are in the folder. The server will try to reload the configuration file and the .env file if either have changed.

> Many configuration values support hot reloading, meaning they can be modified without restarting the server.

After having set up your config.toml, you may want to copy it as for example config.toml.default, to be able to quickly restore your initial configuration. This is entirely optional, though.

## bomnipotent_server

This is the binary that runs BOMnipotent Server. You can download any version for your server platform from [www.bomnipotent.de](https://www.bomnipotent.de/downloads/).

In principle, all BOMnipotent Server needs to run is to know the path to its config file. If you run the binary and provide the path as the first argument, you have created a working server instance. However, your terminal is now eternally blocked, and the service will not restart if you reboot your system. The rest of this section only serves to ensure that the operating system properly supports the server.

> Unlike BOMnipotent Client, which runs under all major operating systems, BOMnipotent Server is currently only supported under Linux and Windows. If you want to host it on a server running MacOS, please [create an issue](https://github.com/Weichwerke-Heidrich-Software/bomnipotent_doc/issues).

{{< tabs >}}
{{% tab title="Linux" %}}
> This setup requires your distribution to incorporate systemd.
>
> If you're not sure if it does, it probably does.
>
> If you're sure that it does not, you probably don't need these instructions.

Create the file "/etc/systemd/system/bomnipotent.service" with the following content:
``` php
[Unit]
Description=BOMnipotent Server
After=network.target

[Service]
ExecStart=/path/to/bomnipotent_server /path/to/bomnipotent_config/config.toml
WorkingDirectory=/path/to/bomnipotent_config
Restart=on-failure
User=<youruser>

[Install]
WantedBy=multi-user.target
```
Make sure to adjust the values to your specific server. Then run:
```
sudo systemctl daemon-reexec
sudo systemctl enable --now bomnipotent.service
```

{{% /tab %}}
{{% tab title="Windows" %}}
Open the Task Scheduler (taskschd.msc).

In the right panel, click Create Task.

In the "General" tab:
- Name the task as "BOMnipotent Server".
- Choose "Run whether user is logged on or not".

In the "Triggers" tab:
- Click "New" and select "At startup".

In the "Actions" tab:
- Click "New" and set the action to "Start a program".
- For "Program/script", select "C:\path\to\bomnipotent_server.exe" (adjust accordingly).
- In "Add arguments (optional)", provide "C:\path\to\bomnipotent_config\config.toml" (adjust accordingly).

Click "OK" to save the task.
{{% /tab %}}
{{< /tabs >}}
