+++
title = "Vulnerabilities"
slug = "vulnerabilities"
weight = 30
description = "Learn how to list known vulnerabilities affecting a product using the bomnipotent_client command and understand the output details, including CVSS, TLP, and CSAF."
+++

## List

To dispaly a list of known vulnerabilities accessible to you, call:


```
bomnipotent_client vulnerability list
```

``` {wrap="false" title="output"}
╭─────────────┬─────────┬─────────────────────┬───────────────────────────┬───────┬──────────┬─────────┬─────────────────╮
│ Product     │ Version │ Vulnerability       │ Description               │ Score │ Severity │ TLP     │ CSAF Assessment │
├─────────────┼─────────┼─────────────────────┼───────────────────────────┼───────┼──────────┼─────────┼─────────────────┤
│ BOMnipotent │ 1.0.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│             │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│             │         │                     │ t`                        │       │          │         │                 │
│ vulny       │ 0.1.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│             │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│             │         │                     │ t`                        │       │          │         │                 │
╰─────────────┴─────────┴─────────────────────┴───────────────────────────┴───────┴──────────┴─────────┴─────────────────╯
```

The output contains an ID for the vulnerability, a description, and a [CVSS value](https://www.first.org/cvss/) and/or severity if available. It also contains a [TLP Classification](https://www.first.org/tlp/) derived from that of the affected product, and ideally a [CSAF Assessment](https://www.csaf.io/) by the vendor.

The list can be filtered by name and/or version of the affected product:

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client vulnerability list --name=vulny --version=0.1.0
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client vulnerability list -n vulny -v 0.1.0
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
╭─────────┬─────────┬─────────────────────┬───────────────────────────┬───────┬──────────┬─────────┬─────────────────╮
│ Product │ Version │ Vulnerability       │ Description               │ Score │ Severity │ TLP     │ CSAF Assessment │
├─────────┼─────────┼─────────────────────┼───────────────────────────┼───────┼──────────┼─────────┼─────────────────┤
│ vulny   │ 0.1.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│         │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│         │         │                     │ t`                        │       │          │         │                 │
╰─────────┴─────────┴─────────────────────┴───────────────────────────┴───────┴──────────┴─────────┴─────────────────╯
```

To display only those vulnerabilities that are not yet covered by a CSAF advisory, call:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client vulnerability list --unassessed
bomnipotent_client vulnerability list --unassessed=true # does the same
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client vulnerability list -u
bomnipotent_client vulnerability list -u true # does the same
```
{{% /tab %}}
{{< /tabs >}}

The behaviour here is special: If there are any unassessed vulnerabilities, the client will return an error code. This is meant to ease the integration with scripts that regularly check for new vulnerabilities, as is for example described in the [section about CI/CD](/integration/ci-cd).

Listing only vulnerabilities that have an advisory is also possible, but does not exhibit any special client behaviour:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client vulnerability list --unassessed=false
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client vulnerability list -u false
```
{{% /tab %}}
{{< /tabs >}}

The CSAF document is a crucial part of vulnerability handling, because it tells you, the user of the product, how you should react to this supply chain vulnerability. Read the [next section](/client/consumer/csaf-docs/) to find out how to access them.

## Existence

{{< exists-subcommand-en >}}

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client vulnerability exists --version=0.1.0
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client vulnerability exists -v 0.1.0
```
{{% /tab %}}
{{< /tabs >}}
