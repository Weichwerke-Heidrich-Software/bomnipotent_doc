+++
title = "Output Mode"
slug = "output-mode"
weight = 70
+++

Withouth any specifications of the output-mode, BOMnipotent Client prints its log messages either to stdout, or to a configured [log-file](/client/basics/log-file/). This is great if it used by humans, but not so useful for automation. This is why BOMnipotent Client offers the two additional output-modes ["code"](#code) and ["raw"](#raw). They modify which output is printed where.

## Output Streams

In output-modes "code" or "raw", only the HTTP code or the response body are printed to stdout. If you [configure a log-file](/client/basics/log-file/), any logs up to the specified [log-level](/client/basics/log-level/) will be stored there.

If on the other hand you do not specify a log-file, BOMnipotent still wants you to know if something goes wrong. This is why, in this case, logs of severity "error" or "warn" are printed to stderr.


## Modes

### Code

The code output prints only the [HTTP status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the response to stdout.
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --output-mode=code health
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client -o code health
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
200
```

This can come in handy if you want to use BOMnipotent Client in a script:
``` bash
#!/bin/bash
set -e # Return on error
# ...other code...
./bomnipotent_client \
    --output-mode=code \
    --domain=$domain \
    --log-level=debug \
    --log-file="/tmp/loggy.log" \
    session login
code=$(./bomnipotent_client health)
if (( code != 200 )); then
    echo "Server at $domain is not healthy!"
    cat /tmp/loggy.log
    exit 1;
fi
```

> Note that there is no newline or carriage return character at the end of the output.

**Attention:** In code mode, BOMnipotent Client always exits with a terminal exit code of 0 (signaling success) if it can obtain *any* HTTP code. This way, the program is easier to use inside scripts that return on errors.

### Raw

For calls to BOMnipotent Client that access some structured data, the raw output prints the response body, which is typically data in JSON format.

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --output-mode=raw bom list
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client -o raw bom list
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[{"name":"BOMnipotent","version":"1.0.0","timestamp":"2025-01-03T05:38:03Z","tlp":null,"components":350}]
```

The output can then easily be parsed and processed by your program logic.

> Note that there is no newline or carriage return character at the end of the output.
