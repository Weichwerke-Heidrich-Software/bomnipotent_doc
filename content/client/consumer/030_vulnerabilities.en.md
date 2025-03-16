+++
title = "Listing Vulnerabilities"
slug = "vulnerabilities"
weight = 30
description = "Learn how to list known vulnerabilities affecting a product using the bomnipotent_client command and understand the output details, including CVSS, TLP, and CSAF."
+++

To dispaly a list of known vulnerabilities affecting a product, call "vulnerability", "list" and then name and version of the product:

```
bomnipotent_client vulnerability list vulny 0.1.0
```

``` {wrap="false" title="output"}
╭─────────┬─────────┬─────────────────────┬───────────────────────────┬───────┬──────────┬─────────┬─────────────────╮
│ Product │ Version │ Vulnerability       │ Description               │ Score │ Severity │ TLP     │ CSAF Assessment │
├─────────┼─────────┼─────────────────────┼───────────────────────────┼───────┼──────────┼─────────┼─────────────────┤
│ vulny   │ 0.1.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│         │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│         │         │                     │ t`                        │       │          │         │                 │
╰─────────┴─────────┴─────────────────────┴───────────────────────────┴───────┴──────────┴─────────┴─────────────────╯
```

Product name and version are optional positional arguments. If you do not provide a version, you will get the output for all versions of the product, and if you do not provide either, the output of all products accessible to you.


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

The CSAF document is a crucial part, because it tells you, the user of the product, how you should react to this supply chain vulnerability. Read the [next section](/client/consumer/csaf-docs/) to find out how to access them.
