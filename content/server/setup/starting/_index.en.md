+++
title = "Starting the Server"
weight = 10
description = "Learn how to set up your BOMnipotent Server with various methods like Docker Compose or as a standalone application."
+++

Several setup variants are presented here. You can pick the one best suited to your needs, and modify it at will.
- The [setup via docker compose](/server/setup/docker-compose/) is probably the easiest, and directly exposes your server to the internet. Choose this method if you have a dedicated system and IP just for BOMnipotent Server.
- The [setup including a proxy](/server/setup/starting/docker-compose-with-proxy/) is very similar, but also sets up a reverse proxy. Choose this method if you potentially want to offer more than one service from the same system and IP.
- The [standalone setup](/server/setup/starting/standalone/) avoids the overhead of containerisation, at the cost of, well, containerisation. Choose this method if you are experienced in more classical server setups.

After following the steps of one of the variants, your server has a default configuration and should be reachable from the internet. After that, you should [create an admin user account](/server/setup/admin).
