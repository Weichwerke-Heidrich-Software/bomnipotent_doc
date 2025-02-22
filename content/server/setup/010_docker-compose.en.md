+++
title = "Via Docker Compose"
slug = "docker-compose"
weight = 10
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
# The db_url has the structure [db_client]://[user]:[password]@[container]:[port]/[db]
# Note that ${BOMNIPOTENT_DB_PW} references an environment variable.
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
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
# Giving the setup a name is optional, it will be derived by docker otherwise.
name: bomnipotent_server_containers

# The docker containers need to communicate, and they need a network for that.
networks:
  # This network needs a reference
  bomnipotent_network:
    # Since the containers are on the same docker host, "bridge" is a reasonable driver choice.
    driver: bridge
    # Giving the network the same name as the reference is ok.
    name: bomnipotent_network

volumes:
  # Define the volume for persistent data storage
  bomnipotent_data:
    driver: local

services:
  bomnipotent_db:
    # Name of the database container
    container_name: bomnipotent_db
    deploy:
      resources:
        # Limit the CPU usage to 0.5 cores
        limits:
          cpus: "0.5"
        # Limit the memory usage to 512MB
          memory: "512M"
    environment:
      # Set the database name
      POSTGRES_DB: bomnipotent_db
      # Set the database user
      POSTGRES_USER: bomnipotent_user
      # Set the database password from the .env file variable
      POSTGRES_PASSWORD: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      # Check if the database is ready
      test: ["CMD-SHELL", "pg_isready -U bomnipotent_user -d bomnipotent_db"]
      # Interval between health checks
      interval: 60s
      # Timeout for each health check
      timeout: 10s
      # Number of retries before considering the container unhealthy
      retries: 5
      # Start period before the first health check
      start_period: 10s
    # Use the specified PostgreSQL image
    # You may ddjust the container tag at will
    image: postgres:17-alpine3.21
    logging:
      # Use the local logging driver
      driver: local
      options:
        # Limit the log size to 10MB
        max-size: "10m"
        # Keep a maximum of 3 log files
        max-file: "3"
    networks:
      # Connect to the specified network
      - bomnipotent_network
    # Restart the container if it has stopped for some reason other than a user command
    restart: always
    volumes:
      # Mount the volume for persistent data storage
      - bomnipotent_data:/var/lib/postgresql/data

  bomnipotent_server:
    # Name of the server container
    container_name: bomnipotent_server
    depends_on:
      # Ensure the database service is healthy before starting the server
      bomnipotent_db:
        condition: service_healthy
    deploy:
      resources:
        # Limit the CPU usage to 0.5 cores
        limits:
          cpus: "0.5"
        # Limit the memory usage to 512MB
          memory: "512M"
    environment:
      # Pass the database password on to the server.
      BOMNIPOTENT_DB_PW: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      # Check if the server is healthy
      # Your TLS certificate is most likely not valid for "localhost"
      # Hence the --insecure flag
      test: ["CMD-SHELL", "curl --fail --insecure https://localhost:8443/health || exit 1"]
      # Interval between health checks
      interval: 60s
      # Timeout for each health check
      timeout: 10s
      # Number of retries before considering the container unhealthy
      retries: 5
      # Start period before the first health check
      start_period: 10s
    # This is the official docker image running a BOMnipotent Server instance.
    image: wwhsoft/bomnipotent_server:latest
    logging:
      # Use the local logging driver
      driver: local
      options:
        # Limit the log size to 10MB
        max-size: "10m"
        # Keep a maximum of 3 log files
        max-file: "3"
    networks:
      # Connect to the specified network
      - bomnipotent_network
    ports:
      # Map port 443 on the host to port 8443 on the container
      # This allows to connect to it via encrypted communication from the internet
      - target: 8443
        published: 443
    # Restart the container if it has stopped for some reason other than a user command
    restart: always
    volumes:
      # Mount the host
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      # Bind mount the SSL directory
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true
```
{{% /tab %}}
{{% tab title="not annotated" %}}
```yaml
name: bomnipotent_server_containers

networks:
  bomnipotent_network:
    driver: bridge
    name: bomnipotent_network

volumes:
  bomnipotent_data:
    driver: local

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
    image: postgres:17-alpine3.21
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - bomnipotent_network
    restart: always
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
    environment:
      BOMNIPOTENT_DB_PW: ${BOMNIPOTENT_DB_PW}
    healthcheck:
      test: ["CMD-SHELL", "curl --fail --insecure https://localhost:8443/health || exit 1"]
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
      - target: 8443
        published: 443
    restart: always
    volumes:
      - type: bind
        source: ./bomnipotent_config
        target: /etc/bomnipotent_server/configs/
        read_only: true
      - type: bind
        source: /etc/ssl
        target: /etc/ssl
        read_only: true
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
