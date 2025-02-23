+++
title = "Listing Vulnerabilities"
slug = "vulnerabilities"
weight = 30
+++

To dispaly a list of known vulnerabilities affecting a product, call "vulnerability", "list" and then name and version of the product:

```bash
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

The output contains an ID for the vulnerability, a description, and a [CVSS-Score](https://www.first.org/cvss/) and/or severity if available. It also contains a [TLP Classification](https://www.first.org/tlp/) derived from that of the affected product, and ideally a [CSAF Assessment](https://www.csaf.io/) by the vendor.

The CSAF document is a crucial part, because it tells you, the user of the product, how you should react to this supply chain vulnerability. Read the [next section](/client/consumer/csaf-docs/) to find out how to access them.
