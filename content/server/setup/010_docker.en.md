+++
title = "Setup via Docker Compose"
slug = "docker"
weight = 10
draft = true
+++

The recommended and easiest setup for BOMnipotent Server uses [docker compose](https://docs.docker.com/compose/).

## Suggested File Structure

The suggested file structure in the favourite directory of your server looks like this:
```
├── .env
├── bomnipotent_config
│   ├── config.toml
│   └── config.toml.default
├── compose.yaml
```

This tutorial will walk through the files and explain them one by one.

## .env

BOMnipotent server communicates with a database. Currently, only [PostgreSQL](https://www.postgresql.org/) is supported. The database is password protected. It is best practice to store the password inside a separate .env file instead of directly in the compose.yaml.

> The name of the file must be ".env", otherwise docker will not recognise it.

Your .env file should look like this:
```
BOMNIPOTENT_DB_PW=<your-database-password>
```

If you are using a versioning system to store your setup, do not forget to add ".env" to your .gitignore or analogous ignore file!

> To put the security into perspective: The compose file will **not** directly expose the PostgreSQL container to the internet. The password is therefore only used for calls within the container network.


## config.toml

BOMnipotent Server needs a configuration file, which is explained in more detail in [another section](server/configuration/config-file/).

> The name of the file is arbitrary in principle, but the ready-to-deploy BOMnipotent Server docker container is set up to look for "config.toml".

An almost minimal configuration looks like this:
```toml
# Make port 8080 accept unencrypted connections for the local healthcheck
allow_http = true
# The db_url has the structure [db_client]://[user]:[password]@[container]:[port]/[db]
db_url = "postgres://bomnipotent_user:<your-database-password>@bomnipotent_db:5432/bomnipotent_db"
# Domain behind which bomnipotent server will be hosted
domain = "https://<your-domain>.<top-level>"
# Possible values: error, warning, info, debug, trace
log_level = "info"
# The path to your full TLS certificate chain
certificate_chain_path = "/etc/ssl/certs/<your-TLS-certificate-chain.crt>"
# The path to your secret TLS key
secret_key_path = "/etc/ssl/private/<your-secret-TLS-key>"

# Publisher data according to the CSAF Standard linked below
[publisher_data]
# This is most likely the enum variant you want
category = "vendor"
# Contact details are optional and in free form
contact_details = "<For security inquiries, please contact us at...>"
name = "<Provide the name of your organsiation>"
# Namespace of your organisation, in form of a complete URL
namespace = "https://<your-domain>.<top-level>"
```
Fill in the braces with your data.

The publisher data is used to comply with the [OASIS CSAF standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3218-document-property---publisher).

The publisher data namespace can and usually will be different from the domain:
* The domain is used to point to your BOMnipotent server instance, for example "https://bomnipotent.wwh-soft.com"
* The namespace is a URL as well, but is used to identify your organsiation accross various security documents. In case of Weichwerke Heidrich Software, it is "https://wwh-soft.com".

It is recommended to store your config.toml file inside a dedicated directory, "bomnipotent_config" in this example. The docker compose file will grant read access to this folder. This setup has two advantages:
* In the unlikely case of a security breach of the BOMnipotent Server container, an attacker would only have access to you config directory, and nothing else on your server.
* BOMnipotent Server will watch the directory for changes and will try to reload the configuration file if it has changed. This does **not** work when exposing only a single file to the docker container.

> Many configuration values support hot reloading, meaning they can be modified without restarting the server. In the above minimal config, the log_level is the most meaningful example that comes to mind.

After having set up your config.toml, you may want to copy it as for example config.toml.default, to be able to quickly restore your initial configuration. This is entirely optional, though.

## compose.yaml

The compose file is where you specify the container setup. Once it is running smoothly, it does not need to be modified very often, but initially understanding it can take some time if you are new to docker.

> The file needs to be called "compose.yaml", docker can be a bit pecky otherwise.

A completely ready to deploy compose file looks like this:
{{< tabs >}}
{{% tab title="annotated" %}}
```yaml
# TODO: Annotate
name: bomnipotent_server_containers

networks:
  bomnipotent_network:
    driver: bridge
    name: bomnipotent_network

services:
  bomnipotent_db:
    container_name: bomnipotent_db
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    environment:
      POSTGRES_DB: bomnipotent_db
      POSTGRES_USER: bomnipotent_user
      POSTGRES_PASSWORD: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U bomnipotent_user -d bomnipotent_db"]
      interval: 60s
      timeout: 10s
      retries: 5
      start_period: 10s
    image: postgres:17-alpine3.20
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    restart: unless-stopped
    volumes:
      - bomnipotent_data:/var/lib/postgresql/data

  bomnipotent_server:
    container_name: bomnipotent_server
    depends_on:
      bomnipotent_db:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
      interval: 60s
      timeout: 10s
      retries: 5
      start_period: 10s
    image: wwhsoft/bomnipotent_server:latest
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    ports:
      - "443:8443"
    restart: unless-stopped
    volumes:
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true

volumes:
  bomnipotent_data:
    driver: local
```
{{% /tab %}}
{{% tab title="not annotated" %}}
```yaml
name: bomnipotent_server_containers

networks:
  bomnipotent_network:
    driver: bridge
    name: bomnipotent_network

services:
  bomnipotent_db:
    container_name: bomnipotent_db
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    environment:
      POSTGRES_DB: bomnipotent_db
      POSTGRES_USER: bomnipotent_user
      POSTGRES_PASSWORD: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U bomnipotent_user -d bomnipotent_db"]
      interval: 60s
      timeout: 10s
      retries: 5
      start_period: 10s
    image: postgres:17-alpine3.20
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    restart: unless-stopped
    volumes:
      - bomnipotent_data:/var/lib/postgresql/data

  bomnipotent_server:
    container_name: bomnipotent_server
    depends_on:
      bomnipotent_db:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
      interval: 60s
      timeout: 10s
      retries: 5
      start_period: 10s
    image: wwhsoft/bomnipotent_server:latest
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    ports:
      - "443:8443"
    restart: unless-stopped
    volumes:
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true

volumes:
  bomnipotent_data:
    driver: local
```
{{% /tab %}}
{{< /tabs >}}

Store this as "compose.yaml". Then, call:
{{< tabs >}}
{{% tab title="long" %}}
```bash
docker compose --detach
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
docker compose -d
```
{{% /tab %}}
{{< /tabs >}}

Your server is now up and running!

> It is not? Please [contact me](https://www.bomnipotent.de/contact)!

Run `docker ps` to check if it is healthy.
