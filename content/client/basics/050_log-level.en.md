+++
title = "Log Level"
slug = "log-level"
weight = 50
+++

BOMnipotent Client offers several severity levels of logs:
- error
- warn
- info (default)
- debug
- trace

They can be selected via:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --log-level=<LEVEL> <COMMAND>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client -l <LEVEL> <COMMAND>
```
{{% /tab %}}
{{< /tabs >}}

This defines the minimum severity level for a message to be logged: Choosing log level debug makes BOMnipotent print all messages of severity error, warn, info and debug, but not trace.

By default, BOMnipotent Client logs messages to stdout, regardless of severity level. You can instruct it to [log to a file](/client/basics/log-file/) instead.

## Info, Warn and Error

The default log-level is info. It prints some information, but does not overwhelm the user.

```
bomnipotent_client health
```
``` {wrap="false" title="output"}
[INFO] Service is healthy
```

```
bomnipotent_client bom list
```
``` {wrap="false" title="output"}
[INFO]
╭─────────────┬─────────┬─────────────────────────┬─────────┬────────────╮
│ Product     │ Version │ Timestamp               │ TLP     │ Components │
├─────────────┼─────────┼─────────────────────────┼─────────┼────────────┤
│ BOMnipotent │ 1.0.0   │ 2025-02-01 03:31:50 UTC │ Default │ 363        │
╰─────────────┴─────────┴─────────────────────────┴─────────┴────────────╯
```

Or, in case of an error:
``` {wrap="false" title="output"}
[ERROR] Received response:
404 Not Found
BOM Volcano_1.0.0 not found in database
```

## Debug

The debug output mode prints some additional information which may be of interest when looking for the cause of an error in the input or setup:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --log-level=debug health
```
{{% /tab %}}
{{% tab title="short" %}}
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

In output mode trace, BOMnipotent additionally prints the module where the log message originated. This is mainly interesting for finding the cause of an error *in the program itself*.
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --log-level=trace health
```
{{% /tab %}}
{{% tab title="short" %}}
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
