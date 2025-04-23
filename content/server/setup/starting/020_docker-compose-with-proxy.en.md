+++
title = "Docker Compose incl. Reverse Proxy"
slug = "docker-compose-with-proxy"
weight = 20
draft = true
+++

This variant of the very [similar setup](/server/setup/starting/docker-compose/) with [docker compose](https://docs.docker.com/compose/) not only sets up a running BOMnipotent Server, but also an [nginx](https://nginx.org/en/) reverse proxy.

In very crude terms, the reverse proxy serves as a gateway to your server: It allows you to host several services (BOMnipotent Server, a website, etc.) behind the same IP address. Any request to one of your URLs will end up at the reverse proxy, which then passes them on to the correct service. This is how you land on a different website when you visit [**doc**.bomnipotent.de](https://doc.bomnipotent.de) than when you visit [**www**.bomnipotent.de](https://www.bomnipotent.de), although they are hosted behind the same IP address.

The use of nginx as the reverse proxy is merely a suggestion. You can substitute it with any other server software you prefer.