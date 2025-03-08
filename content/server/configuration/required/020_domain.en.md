+++
title = "Server Domain"
slug = "domain"
weight = 30
+++

BOMnipotent Server is not only reachable per API, but also displays some static XML and HTML pages. One important example is that it may generate [CSAF Provider Metadata](/server/configuration/required/provider-metadata/) for you. As some of these pages reference one another, the server needs to know the full domain behind which it is reachable from the internet.

The parameter is simply called "domain". Providing a protocol is optional, "https" is assumed as a default.

The relevant part in the config file may for example look like this:
{{< tabs >}}
{{% tab title="with protocol" %}}
```toml
domain = "https://bomnipotent.wwh-soft.com"
```
{{% /tab %}}
{{% tab title="without protocol" %}}
```toml
domain = "bomnipotent.wwh-soft.com"
```
{{% /tab %}}
{{< /tabs >}}
