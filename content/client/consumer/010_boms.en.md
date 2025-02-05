+++
title = "BOMs"
slug = "boms"
weight = 10
draft = true
+++

## List

Bills of Materials stand at the forefront of both BOMnipotents functionality and name. A BOM is a list of all components that make up a product. In the context of cybersecurity, the most prominent variant is the Software Bill of Materials (SBOM), but BOMs allow for more general considerations as well.

Running
```bash
bomnipotent_client bom list
```
will list all BOMs accessible to you:
```
╭─────────────┬─────────┬─────────────────────────┬───────────┬────────────╮
│ Product     │ Version │ Timestamp               │ TLP       │ Components │
├─────────────┼─────────┼─────────────────────────┼───────────┼────────────┤
│ BOMnipotent │ 1.0.0   │ 2025-02-01 03:31:50 UTC │ TLP:WHITE │ 363        │
│ BOMnipotent │ 1.0.1   │ 2025-02-01 03:31:50 UTC │ TLP:WHITE │ 363        │
│ vulny       │ 0.1.0   │ 2025-02-02 06:51:40 UTC │ TLP:AMBER │ 63         │
╰─────────────┴─────────┴─────────────────────────┴───────────┴────────────╯
```

BOMs with label {{<tlp-white>}} / {{<tlp-clear>}} are visible to everyone. In this example, your account has access to one BOM with label {{<tlp-amber>}}.

TODO

## Download

TODO
