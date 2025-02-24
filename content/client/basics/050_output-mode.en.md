+++
title = "Output Mode"
slug = "output-mode"
weight = 50
+++

The BOMnipotent client offers several output modes which can be chosen by a global optional argument:
- code
- raw
- error
- warn
- info
- debug
- trace

Output modes [code](#code) and [raw](#raw) have special behaviour treated below. Choosing modes error, warn, info, debug or trace makes BOMnipotent print all messages up to that log level.

## Info, Warn and Error

The default output mode is info. It prints some information, but does not overwhelm the user.

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

Or, in case of an error:
``` {wrap="false" title="output"}
Received response status: 401 Unauthorized
Error: "No approved and currently valid public keys were found for user admin@wwh-soft.com"
```

## Debug

The debug output mode prints some additional information which may be of interest when looking for the cause of an error in the input or setup:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --output=debug health
```
{{% /tab %}}
{{% tab title="short" %}}
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

In output mode trace, BOMnipotent additionally prints the module where the log message originated. This is mainly interesting for finding the cause of an error in the program itself.
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --output=trace health
```
{{% /tab %}}
{{% tab title="short" %}}
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

The code output prints only the [HTTP status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the response.
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --output=code health
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -o code health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
200
```

This can come in handy if you want to use BOMnipotent Client in scripts:
```bash
code=$(./bomnipotent_client --domain=$domain --output=code health)
if (( code != 200 )); then
    echo "Server at $domain is not healthy!"
    exit 1;
fi
```

Note that there is no newline or carriage return character at the end of the output.

## Raw

For calls to BOMnipotent Client that access some structured data, the raw output prints that data in json format **instead** of parsing and processing it.

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --output=raw bom list
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -o raw bom list
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[{"name":"BOMnipotent","version":"1.0.0","timestamp":"2025-01-03T05:38:03Z","tlp":null,"components":350}]
```

The output can then easily be parsed and processed by your program logic.

Note that there is no newline or carriage return character at the end of the output.
