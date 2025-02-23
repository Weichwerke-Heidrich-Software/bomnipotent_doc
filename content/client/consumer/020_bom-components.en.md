+++
title = "Listing Components"
slug = "bom-components"
weight = 20
+++

The purpose of a Bill of Materials is to catalogue components of a product. BOMnipotent Client can be used to list all packages etc. contained in any product that is accessible to your user account. Simply call the client with the arguments "component", "list", and then name and version of the product:

```bash
bomnipotent_client component list vulny 0.1.0
```
``` {wrap="false" title="output"}
╭──────────────┬─────────┬─────────┬───────────────────────────┬───────────────────────────╮
│ Name         │ Version │ Type    │ CPE                       │ PURL                      │
├──────────────┼─────────┼─────────┼───────────────────────────┼───────────────────────────┤
│ aho-corasick │ 1.1.3   │ library │ cpe:2.3:a:aho-corasick:ah │ pkg:cargo/aho-corasick@1. │
│              │         │         │ o-corasick:1.1.3:*:*:*:*: │ 1.3                       │
│              │         │         │ *:*:*                     │                           │
│ aws-lc-rs    │ 1.12.2  │ library │ cpe:2.3:a:aws-lc-rs:aws-l │ pkg:cargo/aws-lc-rs@1.12. │
│              │         │         │ c-rs:1.12.2:*:*:*:*:*:*:* │ 2                         │
│ aws-lc-sys   │ 0.25.0  │ library │ cpe:2.3:a:aws-lc-sys:aws- │ pkg:cargo/aws-lc-sys@0.25 │
│              │         │         │ lc-sys:0.25.0:*:*:*:*:*:* │ .0                        │
│              │         │         │ :*                        │                           │
│ bindgen      │ 0.69.5  │ library │ cpe:2.3:a:bindgen:bindgen │ pkg:cargo/bindgen@0.69.5  │
│              │         │         │ :0.69.5:*:*:*:*:*:*:*     │                           │

...
```

This output is primarily meant to be human-readable. Using the `--output=raw` option makes it machine-readable in principle, but [downloading the complete BOM](client/consumer/boms/) is most likely preferable to parsing this table output.

A vendor of a product should periodically scan the BOM of a product for vulnerabilities, for example by using tools like [grype](/integration/grype/). The [next section](/client/consumer/vulnerabilities/) explains how you as the user of a product can access these list.
