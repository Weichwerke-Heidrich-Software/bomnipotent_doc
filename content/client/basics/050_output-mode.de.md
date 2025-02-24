+++
title = "Ausgabemodus"
slug = "output-mode"
weight = 50
+++

Der BOMnipotent-Client bietet mehrere Ausgabemodi, die über ein globales optionales Argument ausgewählt werden können:
- code
- raw
- error
- warn
- info
- debug
- trace

Die Ausgabemodi [code](#code) und [raw](#raw) haben ein besonderes Verhalten, welches weiter unten behandelt wird. Wenn die Modi error, warn, info, debug oder trace ausgewählt werden, gibt BOMnipotent alle Meldungen bis zu diesem Protokollierungslevel aus.

## Info, Warn und Error

Der Standard-Ausgabemodus ist info. Er gibt einige Informationen aus, überflutet den Benutzer jedoch nicht mit Nachrichten.

``` bash
bomnipotent_client health
```
``` {wrap="false" title="output"}
Service is healthy
```

``` bash
bomnipotent_client bom list
```
``` {wrap="false" title="output"}
╭─────────────┬─────────┬─────────────────────────┬─────────┬────────────╮
│ Product     │ Version │ Timestamp               │ TLP     │ Components │
├─────────────┼─────────┼─────────────────────────┼─────────┼────────────┤
│ BOMnipotent │ 1.0.0   │ 2025-02-01 03:31:50 UTC │ Default │ 363        │
╰─────────────┴─────────┴─────────────────────────┴─────────┴────────────╯
```

Oder, falls ein Fehler auftritt:
``` {wrap="false" title="output"}
Received response status: 401 Unauthorized
Error: "No approved and currently valid public keys were found for user admin@wwh-soft.com"
```

## Debug

Der Debug-Ausgabemodus gibt zusätzliche Informationen aus, die bei der Fehlersuche in der Eingabe oder Konfiguration nützlich sein können:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --output=debug health
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -o debug health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[DEBUG] Looking for session data in /home/simon/.config/bomnipotent/session.toml
[DEBUG] Looking for secret key
[DEBUG] The provided key is a path: /home/simon/git/bomnipotent/test_cryptofiles/admin
[DEBUG] Signing request
[DEBUG] Assembled GET request to http://localhost:8080/health
[DEBUG] starting new connection: http://localhost:8080/
Service is healthy
```

## Trace

Im trace-Modus gibt BOMnipotent zusätzlich das Modul aus, aus dem die Protokollnachricht stammt. Dies ist besonders nützlich, um Fehler im Programm selbst zu identifizieren.
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --output=trace health
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -o trace health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[bomnipotent_client::session_data] [DEBUG] Looking for session data in /home/simon/.config/bomnipotent/session.toml
[bomnipotent_client::keys] [DEBUG] Looking for secret key
[bomnipotent_client::keys] [DEBUG] The provided key is a path: /home/simon/git/bomnipotent/test_cryptofiles/admin
[reqwest::blocking::wait] [TRACE] (ThreadId(1)) park without timeout
[reqwest::blocking::client] [TRACE] (ThreadId(2)) start runtime::block_on
[bomnipotent_client::request] [DEBUG] Signing request
[bomnipotent_client::request] [DEBUG] Assembled GET request to http://localhost:8080/health
[reqwest::blocking::wait] [TRACE] wait at most 30s
[reqwest::blocking::wait] [TRACE] (ThreadId(1)) park timeout 29.99999896s
[reqwest::connect] [DEBUG] starting new connection: http://localhost:8080/
[reqwest::blocking::wait] [TRACE] wait at most 30s
[reqwest::blocking::client] [TRACE] closing runtime thread (ThreadId(2))
[reqwest::blocking::client] [TRACE] signaled close for runtime thread (ThreadId(2))
[reqwest::blocking::client] [TRACE] (ThreadId(2)) Receiver is shutdown
[reqwest::blocking::client] [TRACE] (ThreadId(2)) end runtime::block_on
[reqwest::blocking::client] [TRACE] (ThreadId(2)) finished
[reqwest::blocking::client] [TRACE] closed runtime thread (ThreadId(2))
Service is healthy
```

## Code

Der code-Modus gibt nur den [HTTP Statuscode](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) der Antwort aus.
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --output=code health
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -o code health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
200
```

Das ist besonders nützlich, wenn BOMnipotent-Client in Skripten verwendet wird:
```bash
code=$(./bomnipotent_client --domain=$domain --output=code health)
if (( code != 200 )); then
    echo "Server at $domain is not healthy!"
    exit 1;
fi
```

Beachten Sie, dass am Ende der Ausgabe kein Zeilenumbruch oder Wagenrücklaufzeichen steht.

> "Wagenrücklaufzeichen" ist tatsächlich die deutsche Übersetzung von "carriage return". Abgefahren.

## Raw

Für Aufrufe, die auf strukturierte Daten zugreifen, gibt der raw-Modus die Daten im JSON-Format aus, **anstatt** sie zu analysieren und zu verarbeiten.

{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --output=raw bom list
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -o raw bom list
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[{"name":"BOMnipotent","version":"1.0.0","timestamp":"2025-01-03T05:38:03Z","tlp":null,"components":350}]
```

Die Ausgabe kann dann einfach von der Programmlogik analysiert und weiterverarbeitet werden.

Beachten Sie, dass am Ende der Ausgabe kein Zeilenumbruch oder Wagenrücklaufzeichen steht.
