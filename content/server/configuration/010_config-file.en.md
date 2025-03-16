+++
title = "The Config File"
slug = "config-file"
weight = 10
description = "Configure BOMnipotent Server using a TOML config file. Learn about hot reloading, environment variables, and troubleshooting configuration issues."
+++

Your instance of BOMnipotent Server is configured using a config file. It contains several values, provided in [TOML Format](https://toml.io/en/). The [setup instructions](/server/setup/starting/) each contain a config file that you can fill with your specific data. All configurations accepted by BOMnipotent Server are described in the [rest of this section](/server/configuration/).

## (Re)Loading Configurations

Many configurations support hot reloading. This means that you can change them inside the file, and they take effect without requiring a restart of the server. BOMnipotent Server achieves this by watching for changes of files in the directory that the config file resides in. You can verify a successful reload of the configurations by looking at the logs:
```
docker logs bomnipotent_server -n 1
```
``` {wrap="false" title="output"}
2025-03-06 15:34:45 +00:00 [INFO] Configuration successfully reloaded from "/etc/bomnipotent_server/configs/config.toml"
```
If something does not work as intended, BOMnipotent will also let you know in the logs:
```
docker logs bomnipotent_server -n 6
```
``` {wrap="false" title="output"}
2025-03-06 16:11:03 +00:00 [ERROR] Failed to read config file "/etc/bomnipotent_server/configs/config.toml": Failed to parse config file: TOML parse error at line 5, column 1
  |
5 | starlight_throughput = "16 GW"
  | ^^^^^^^^^^^^^^^^^^^^
unknown field `starlight_throughput`, expected one of `allow_http`, `allow_tlp2`, `certificate_chain_path`, `db_url`, `default_tlp`, `domain`, `dos_prevention_limit`, `dos_prevention_period`, `log_level`, `provider_metadata_path`, `publisher_data`, `secret_key_path`, `tmp_admin`, `user_expiration_period`
```

> If the configuration loading produces an error during server startup, the process is aborted. If the configuration cannot be reloaded for an already running server, then the last valid configuration is left untouched.

The official [BOMnipotent Server docker image](https://hub.docker.com/r/wwhsoft/bomnipotent_server) looks for the config file at the path "/etc/bomnipotent_server/configs/config.toml" inside the container. It is recommended to read-only bind the container path "/etc/bomnipotent_server/configs/" to a directory of your choice on the host machine.

> **Important:** For the hot reloading to work, your docker volume must bind to the **directory** in which the config file is located, **not to the file itself**. With a direct file binding BOMnipotent will not receive file events and thus cannot reload the config on change.

## Environment Variables

Inside your config files, you can reference environment variables. To do so, simply use `${<some-env-var>}` anywhere within the file, where "\<some-env-var\>" is replaced with the name of the variable.

For example, if you provide
{{< tabs >}}
{{% tab title=".env" %}}
```
BOMNIPOTENT_DB_PW=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="bash" %}}
```
export BOMNIPOTENT_DB_PW=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="cmd" %}}
```
set BOMNIPOTENT_DB_PW=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="ps1" %}}
```
$env:BOMNIPOTENT_DB_PW = "eHD5B6S8Kze3"
```
{{% /tab %}}
{{% tab title="docker" %}}
```
docker run -e BOMNIPOTENT_DB_PW=eHD5B6S8Kze3 wwhsoft/bomnipotent_server --detach
```
{{% /tab %}}
{{< /tabs >}}
you can use it inside your config.toml like this:
```toml
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
```

> You wouldn't actually use this publicly available example passwort, would you?

BOMnipotent Server supports reading variables from a .env file. If a file with that exact name, ".env", is located next to your config file, the server will try to evaluate it before loading the config.

Changing the .env file while BOMnipotent Server is running will trigger a hot reloading and a re-evaluation of both the .env and the config file.
