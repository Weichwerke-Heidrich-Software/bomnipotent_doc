+++
title = "Port Binding"
slug = "port-binding"
weight = 60
description = "Learn how to configure BOMnipotent's HTTP and HTTPS port bindings."
+++

While IP addresses are used to identify your server on the internet, ports are used to identify individual services running on it. Upon startup, BOMnipotent offers one or two services: An HTTP service for unencrypted communication, an HTTPS service for encrypted communication, or both.

> **Important:** Use **un**encrypted communication only **within** a machine! Pure HTTP communication over the internet is a thing of the past, and rightly so.

By default, BOMnipotent offers its services over the ports 8080 and 8443. It does so to avoid collisions, and because it is primarily intended to be run inside a container. If you want to run BOMnipotent without the container abstraction, you can instead offer the services via the ports typically associated with HTTP and HTTPS:
```toml
http_port = 80 # Default is 8080
https_port = 443 # Default is 8443
```
Any other unsigned 16 bit number will also do.
