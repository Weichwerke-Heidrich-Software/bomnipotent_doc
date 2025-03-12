+++
title = "BOMs"
slug = "boms"
weight = 10
description = "Learn about Bills of Materials (BOMs) in cybersecurity, how to list and download them using the BOMnipotent Client, and file storage details."
+++

## List

Bills of Materials stand at the forefront of both BOMnipotents functionality and name. A BOM is a list of all components that make up a product. In the context of cybersecurity, the most prominent variant is the Software Bill of Materials (SBOM), but BOMs allow for more general considerations as well.

Running
```bash
bomnipotent_client bom list
```
will list all BOMs accessible to you:
``` {wrap="false" title="output"}
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
``` {wrap="false" title="output"}
[INFO] Storing BOMs under ./boms
```

This will store the BOMs in the provided folder ("./boms", in this example). It will create the folder structure if it does not already exist. The BOMs are stored in files following the naming scheme `{product name}_{product version}.cdx.json`.

> To avoid inconsistent behaviour accross operating systems, the name and version of the product are converted into lowercase, and most special characters are replaced by an underscore '_'. This means that, in principle, different products could lead to the same filename. In that case, BOMnipotent will display an error instead of silently overwriting a file.


```bash
tree ./boms/
```
``` {wrap="false" title="output"}
./boms/
├── bomnipotent_1.0.0.cdx.json
├── bomnipotent_1.0.1.cdx.json
└── vulny_0.1.0.cdx.json

1 directory, 3 files
```

Before requesting files for download, BOMnipotent Client makes an inventory of the BOMs already present in the folder, and downloads only the missing ones.

## Get

You can directly display the contents of a single BOM to the consolte output by calling
```bash
bomnipotent_client bom get <NAME> <VERSION>
```
``` {wrap="false" title="output (cropped)"}
{
  "$schema": "http://cyclonedx.org/schema/bom-1.6.schema.json",
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "serialNumber": "urn:uuid:60d5a033-6d54-4ac4-a5fa-824d0b04c718",
  "version": 1,
  "metadata": {
    "timestamp": "2025-02-23T07:23:33+01:00",
    "tools": {
      "components": [
...
```

This is especially useful if you want to use the contents of this BOM in a script. For example, to [check for vulnerabilities](/integration/grype/) in the supply chain, you could call:
```bash
bomnipotent_client bom get <NAME> <VERSION> | grype
```
``` {wrap="false" title="output"}
NAME  INSTALLED  FIXED-IN  TYPE        VULNERABILITY        SEVERITY 
ring  0.17.10    0.17.12   rust-crate  GHSA-4p46-pwfr-66x6  Medium
```
