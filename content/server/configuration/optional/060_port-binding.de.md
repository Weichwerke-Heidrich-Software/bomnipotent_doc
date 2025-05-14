+++
title = "Port Bindung"
slug = "port-binding"
weight = 60
description = "Lernen Sie, wie Sie BOMnipotents HTTP und HTTPS Port-Bindung konfigurieren können."
+++

Während IP-Adressen zur Identifizierung Ihres Servers im Internet verwendet werden, dienen Ports zur Identifizierung der darauf laufenden Dienste. Beim Start bietet BOMnipotent ein oder zwei Dienste an: einen HTTP-Dienst für unverschlüsselte Kommunikation, einen HTTPS-Dienst für verschlüsselte Kommunikation, oder beides.

> **Wichtig:** Verwenden Sie **un**verschlüsselte Kommunikation nur **innerhalb** eines Rechners! Reine HTTP-Kommunikation über das Internet gehört der Vergangenheit an, und das zu Recht.

Standardmäßig bietet BOMnipotent seine Dienste über die Ports 8080 und 8443 an. Dies geschieht, um Kollisionen zu vermeiden und weil es primär für die Ausführung in einem Container vorgesehen ist. Wenn Sie BOMnipotent ohne die Containerabstraktion ausführen möchten, können Sie die Dienste stattdessen über die Ports anbieten, die typischerweise mit HTTP und HTTPS verknüpft sind:
```toml
http_port = 80 # Standard ist 8080
https_port = 443 # Standard ist 8443
```
Jede andere vorzeichenlose 16-Bit-Zahl ist ebenfalls möglich.
