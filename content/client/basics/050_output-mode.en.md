+++
title = "Output Mode"
slug = "output-mode"
weight = 50
+++

The BOMnipotent client offers several output modes which can be chosen by a global optional argument.

## Normal

The normal output mode is the default and does not have to be specified. It prints some information, but does not overwhelm the user.

``` bash
bomnipotent_client health
```
```
Service is healthy
```


``` bash
bomnipotent_client bom list
```
```
+-------------+---------+-------------------------+---------+------------+
| name        | version | timestamp               | tlp     | components |
+-------------+---------+-------------------------+---------+------------+
| BOMnipotent | 1.0.0   | 2025-01-03 05:38:03 UTC | Default | 350        |
+-------------+---------+-------------------------+---------+------------+
```

Or, in case of an error:
```
Received response status: 401 Unauthorized
Error: "No approved and currently valid public keys were found for user admin@wwh-soft.com"
```

## Verbose

The verbose mode prints some additional information which may be of interest for debugging:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --output=verbose health
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -o verbose health
```
{{% /tab %}}
{{< /tabs >}}
```
Assembled GET request to http://localhost:62080/health
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

```
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

For calls to BOMnipotent Client that access some structured data, the raw output prints that data in json format instead of parsing and processing it.

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

```
[{"name":"BOMnipotent","version":"1.0.0","timestamp":"2025-01-03T05:38:03Z","tlp":null,"components":350}]
```

The output can then easily be parsed and processed by your program logic.

Note that there is no newline or carriage return character at the end of the output.
