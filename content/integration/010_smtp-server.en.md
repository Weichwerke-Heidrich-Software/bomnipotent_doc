+++
title = "SMTP Server"
slug = "smtp-server"
weight = 10
+++

## Direct SMTP Server Communication

To let BOMnipotent Server directly communicate with your email server, set up the [smtp part](/server/configuration/required/smtp/) of your configuration file to look roughly like this:
```toml
[smtp]
user = "you@yourdomain.com"
endpoint = "your.smtp.host"
secret = "${SMTP_SECRET}"
```
The exact form will strongly depend on your email provider. Some may require the full email address as the user, others may not.

Clients like Mozilla Thunderbird are usually very good at deducing the required parameters. If you're at a loss, look for them there.

## Communication via SMTP Relay

If you have more than one service that sends email it can be benficial to locally run an SMTP relay station. It offers a single endpoint for your setup to communicate with the mail server.

There are several docker containers that offer SMTP relay functionality. This tutorial focuses on [crazymax/msmtpd](https://github.com/crazy-max/docker-msmtpd), because it has the best security posture among the lightweight solutions.

### Running Relay via Docker Compose

Add the following service to your compose.yaml file:
``` yaml
  smtp_relay:
    container_name: smtp_relay
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "512M"
    environment:
      TZ: Europe/Berlin # Replace with your preferred timezone
      SMTP_HOST: your.smtp.host # Replace with the correct endpoint
      SMTP_PORT: 465
      SMTP_TLS: on
      SMTP_STARTTLS: off
      SMTP_TLS_CHECKCERT: on
      SMTP_AUTH: login
      SMTP_USER: you@yourdomain.com # Replace with your username
      SMTP_FROM: you@yourdomain.com # Replace with your email address
      SMTP_PASSWORD: ${SMTP_PASSWORD}
      SMTP_DOMAIN: localhost
    healthcheck:
      test: ["CMD", "msmtp", "--version"]
      interval: 30s
      timeout: 10s
      retries: 3
    image: crazymax/msmtpd
    logging:
      driver: local
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - smtp_network
    restart: unless-stopped
```

This will spin up the container, connecting to Port 465 (the default for SMTPS protocol) of the SMTP Host, encrypting with TLS and not STARTTLS. It will listen on port 2500, which is not obvious from the input but the default behaviour of msmtp.

The modification of your compose file is not yet done, though!

Under networks, you have to declare the smtp_network:
``` yaml
networks:
  smtp_network:
    driver: bridge
    name: smtp_network
```

You also need to add the network to any container that is supposed to contact it. You may also want for these containers to depend on the smtp_relay, so that they don't start before the relay station is ready:
``` yaml
  bomnipotent_server:
    container_name: bomnipotent_server
    depends_on:
      smtp_relay:
        condition: service_healthy
    ...
    networks:
      - smtp_network
```

Aside from the modifications to the compose file, your .env file or your environment needs to provide the secret or password for your mail provider:
{{< tabs >}}
{{% tab title=".env" %}}
```
SMTP_PASSWORD=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="bash" %}}
```
export SMTP_PASSWORD=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="cmd" %}}
```
set SMTP_PASSWORD=eHD5B6S8Kze3
```
{{% /tab %}}
{{% tab title="ps1" %}}
```
$env:SMTP_PASSWORD = "eHD5B6S8Kze3"
```
{{% /tab %}}
{{< /tabs >}}

In your BOMnipotent Server config file, you can now modify your smtp section to connect to the relay via the docker network:
``` toml
[smtp_config]
user = "you@yourdomain.com"
endpoint = "smtp://smtp_relay:2500"
```

### Running Relay in standalone Docker Container

If your setup does not have a compose file, you can instead run the container using Docker directly. Make sure that your environment provides a value for SMTP_PASSWORD, and then run
```
docker run --detach -p 2500:2500 --name smtp_relay \
    -e TZ=Europe/Berlin \
    -e SMTP_HOST=your.smtp.host \
    -e SMTP_PORT=465 \
    -e SMTP_TLS=on \
    -e SMTP_STARTTLS=off \
    -e SMTP_TLS_CHECKCERT=on \
    -e SMTP_AUTH=login \
    -e SMTP_USER=you@yourdomain.com \
    -e SMTP_FROM=you@yourdomain.com \
    -e SMTP_PASSWORD=${SMTP_PASSWORD} \
    -e SMTP_DOMAIN=localhost \
    crazymax/msmtpd
```
This does basically the same as the section suggested for the compose file. You again need to replace the values for TZ, SMTP_HOST, SMTP_USER and SMTP_FROM  with the ones for your email provider.

The command above exposes the port 2500 to localhost, which is why your BOMnipotent config needs to be as follows:
``` toml
[smtp_config]
user = "you@yourdomain.com"
endpoint = "smtp://localhost:2500"
```

To stop the container, run:
```
docker stop smtp_relay
```
