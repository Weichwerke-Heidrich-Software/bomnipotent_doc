+++
title = "Managing BOMs"
slug = "managing-boms"
weight = 10
draft = true
+++


> [BOMs for Consumers](/client/consumer/boms/) describes how to list and download the BOMs on the server.

Bills of Materials stand at the forefront of both BOMnipotents functionality and name. A BOM is a list of all components that make up a product. In the context of cybersecurity, the most prominent variant is the Software Bill of Materials (SBOM), but BOMs allow for more general considerations as well.

BOMnipotent expects its BOMs in the structured [CycloneDX](https://cyclonedx.org/) format.

> Consult the [Syft tutorial](/environment/syft) to learn how to generate a Bill of Materials (BOM) for your product.

> For BOM interactions beyond reading, you need the BOM_MANAGEMENT permission. The [User Management Section](/client/system-manager/user-management/) describes how it is granted.

## Upload

To upload a BOM, call:
```bash
bomnipotent_client bom upload <path/to/bom>
```

The BOMnipotent Client will read the file at the provided path and upload its content.



## Modify

TODO

## Delete

TODO