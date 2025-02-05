+++
title = "BOMs"
slug = "boms"
weight = 10
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

## Download

To create a local copy of all boms the server exposes to you, run:
```bash
bomnipotent_client bom download ./boms
```
```
Storing BOMs under ./boms
```

This will store the BOMs in the provided folder ("./boms", in this example). It will create the folder if it does not already exist. The BOMs are stored under files following the naming scheme `{product name}_{product version}.cdx.json`.

Before requesting files for download, BOMnipotent Client makes an inventory of the already presend SBOMs in the folder, and downloads only the missing ones.

```bash
tree ./boms/
```
```
./boms/
├── BOMnipotent_1.0.0.cdx.json
├── BOMnipotent_1.0.1.cdx.json
└── vulny_0.1.0.cdx.json

1 directory, 3 files

```

