+++
title = "Log Level"
slug = "log-level"
weight = 50
+++

BOMnipotent Client bietet verschiedene Schweregrade an Logs:
- error
- warn
- info (default)
- debug
- trace

Diese können wie folgt ausgewählt werden:
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --log-level=<LEVEL> <BEFEHL>
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -l <LEVEL> <BEFEHL>
```
{{% /tab %}}
{{< /tabs >}}

Sie definieren einen minimalen Schweregrad, den eine Nachricht haben muss um ausgegeben zu werden: Mit log-level debug gibt BOMnipotent alle Nachrichten der Schweregrade error, warn, info und debug aus, aber nicht trace.

Standardmäßig schreibt BOMnipotent Client die Nachrichten zu stdout, unabhängig vom Schweregrad. Sie können es stattdessen anweisen, die Logs [in eine Datei](/de/client/basics/log-file/) zu schreiben.

## Info, Warn und Error

Der Standard-Ausgabemodus ist info. Er gibt einige Informationen aus, überflutet den Benutzer jedoch nicht mit Nachrichten.

```
bomnipotent_client health
```
``` {wrap="false" title="Ausgabe"}
[INFO] Service is healthy
```

```
bomnipotent_client bom list
```
``` {wrap="false" title="Ausgabe"}
[INFO]
╭─────────────┬─────────┬─────────────────────────┬─────────┬────────────╮
│ Product     │ Version │ Timestamp               │ TLP     │ Components │
├─────────────┼─────────┼─────────────────────────┼─────────┼────────────┤
│ BOMnipotent │ 1.0.0   │ 2025-02-01 03:31:50 UTC │ Default │ 363        │
╰─────────────┴─────────┴─────────────────────────┴─────────┴────────────╯
```

Oder, falls ein Fehler auftritt:
``` {wrap="false" title="Ausgabe"}
[ERROR] Received response:
404 Not Found
BOM Volcano_1.0.0 not found in database
```

## Debug

Der Debug-Ausgabemodus gibt zusätzliche Informationen aus, die bei der Fehlersuche in der Eingabe oder Konfiguration nützlich sein können:
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --log-level=debug health
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -l debug health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[DEBUG] Looking for secret key
[DEBUG] The provided key is a path: /home/simon/git/bomnipotent/test_cryptofiles/admin
[DEBUG] Reading secret key from provided path "/home/simon/git/bomnipotent/test_cryptofiles/admin"
[DEBUG] Adding trusted root certificate
[DEBUG] Signing request
[DEBUG] Assembled GET request to https://localhost:62443/health
[DEBUG] starting new connection: https://localhost:62443/
[INFO] Service is healthy
```

## Trace

Im Trace-Modus gibt BOMnipotent zusätzlich das Modul aus, aus dem die Nachricht stammt. Dies ist primär nützlich, um Fehler *im Programm selbst* zu identifizieren.
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --log-level=trace health
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -l trace health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[bomnipotent_client] [TRACE] Running command Health with args Arguments {
    domain: Some(
        "https://localhost:62443",
    ),
    email: Some(
        "admin@wwh-soft.com",
    ),
    log_level: Some(
        Trace,
    ),
    log_file: None,
    output_mode: None,
    secret_key: Some(
        "/home/simon/git/bomnipotent/test_cryptofiles/admin",
    ),
    trusted_root: Some(
        "/home/simon/git/bomnipotent/test_cryptofiles/ca.crt",
    ),
    command: Health,
}
[bomnipotent_client::keys] [DEBUG] Looking for secret key
[bomnipotent_client::keys] [DEBUG] The provided key is a path: /home/simon/git/bomnipotent/test_cryptofiles/admin
[bomnipotent_client::keys] [DEBUG] Reading secret key from provided path "/home/simon/git/bomnipotent/test_cryptofiles/admin"
[bomnipotent_client::request] [DEBUG] Adding trusted root certificate
[reqwest::blocking::wait] [TRACE] (ThreadId(1)) park without timeout
[reqwest::blocking::client] [TRACE] (ThreadId(14)) start runtime::block_on
[bomnipotent_client::request] [DEBUG] Signing request
[bomnipotent_client::request] [DEBUG] Assembled GET request to https://localhost:62443/health
[reqwest::blocking::wait] [TRACE] wait at most 30s
[reqwest::blocking::wait] [TRACE] (ThreadId(1)) park timeout 29.999994032s
[reqwest::connect] [DEBUG] starting new connection: https://localhost:62443/
[reqwest::blocking::wait] [TRACE] wait at most 30s
[reqwest::blocking::client] [TRACE] closing runtime thread (ThreadId(14))
[reqwest::blocking::client] [TRACE] signaled close for runtime thread (ThreadId(14))
[reqwest::blocking::client] [TRACE] (ThreadId(14)) Receiver is shutdown
[reqwest::blocking::client] [TRACE] (ThreadId(14)) end runtime::block_on
[reqwest::blocking::client] [TRACE] (ThreadId(14)) finished
[reqwest::blocking::client] [TRACE] closed runtime thread (ThreadId(14))
[bomnipotent_client::output] [INFO] Service is healthy
```