+++
title = "BOMs"
slug = "boms"
weight = 10
description = "Learn how to manage Bills of Materials (BOMs) with BOMnipotent, including uploading, modifying, and deleting."
+++

Bills of Materials stand at the forefront of both BOMnipotents functionality and name. A BOM is a list of all components that make up a product. In the context of cybersecurity, the most prominent variant is the Software Bill of Materials (SBOM), but BOMs allow for more general considerations as well.

> For BOM interactions beyond reading, you need the {{<bom-management-en>}} permission. The section about [Access Management](/client/manager/access-management/) describes how it is granted.

## Uploading

To upload a BOM, call:

{{< example bom_upload >}}

BOMnipotent expects its BOMs in the structured [CycloneDX](https://cyclonedx.org/) JSON format.

> Consult the [Syft tutorial](/integration/syft) to learn how to generate a BOM for your product.

The BOMnipotent Client will read the file at the provided path and upload its content. It can then be viewed by the consumers with appropriate permissions.

> [BOMs for Consumers](/client/consumer/boms/) describes how to list and download the BOMs on the server.

To add a BOM to the database, the BOMnipotent Client has to have some additional information: a name, a version, and optionally a TLP label. The identifiers name and version can either be inferred (recommended), or overwritten, as described below.

### Name and Version

#### Inference (recommended)

BOMnipotent uses name and version to identify a BOM. It tries to infer these from the provided CycloneDX JSON fields "metadata.component.name" and "metadata.component.version". However, according to the [CycloneDX specification](https://cyclonedx.org/docs/1.6/json/#metadata_component), the metadata.component field is optional.

If no version is specified, BOMnipotent instead uses the date of "metadata.timestamp", if available.

To avoid any complications, it is recommended that you specify a name and version when generating the BOM, as is shown in the [Syft tutorial](/integration/syft).

#### Overwriting (not particularly recommended)

If for some reason your BOM lacks a name or version, or if it is incorrect, the BOMnipotent Client offers to remedy that via command line arguments:

{{< example bom_upload_overwrite >}}

**Important:** The BOMnipotent Client will in this case **modify the data** before sending it to the server. It does not modify the local file, as that would be overstepping. This means that your local file and the data on the server are now out-of-sync. What's maybe worse, if you signed your BOM, your signature is now invalid.

If you do use this option, it is thus recommended that you immediately download the BOM from the server (as described in [BOMs for Consumers](/client/consumer/boms/)) and replace your local file with the result.

### TLP Classification

For consumers, BOMnipotent manages access to data using the [Traffic Light Protocol (TLP)](https://www.first.org/tlp/). The
[CycloneDX Format](https://cyclonedx.org/) on the other hand does not currently support document classification.

To tell BOMnipotent how to classify a document, you have two options:
1. Set a [default TLP Label](/server/configuration/optional/tlp-config/) in the server config. This will then be used for all BOMs without further specifications.
2. Provide a tlp classification via command line argument:

{{< example bom_upload_tlp >}}

If you do neither, BOMnipotent will treat any unclassified documents as if they were labelled {{< tlp-red >}}, and will log a warning every time it has to do that.

### Conflict Handling

The combination of name and version of the main component of a BOM need to be unique. Trying to upload another document with the same combination results in an error. You can override this behaviour with the "on-existing" option, telling BOMnipotent to either skip or replace conflicting documents:

{{< example bom_upload_skip_existing >}}

{{< example bom_upload_replace_existing >}}

## Modifying

In the simplest case, modifying an existing BOM works very much like uploading a new one.

{{< example bom_modify >}}

This will infer the name and version from the document, and overwrite the existing content on the server. If the data does not exist on the server, it will return a 404 Not Found error.

### Modifying TLP Label

If a TLP label had previously been assigned to the BOM, a modification of the contents will **not** automatically alter it.

If you want to specify a new TLP label, you can do so via argument:

{{< example bom_modify_tlp>}}

If the contents of the BOM have not changed and you just want to modify the TLP label, you do not need to upload the document again. Instead of providing a path to a file, you can specify name and version of the BOM you want to reclassify:

{{< example bom_modify_only_tlp >}}

If you specify "none", "default" or "unlabelled" as the TLP label, any existing classification will be removed, and the server falls back to the [default TLP Label](/server/configuration/optional/tlp-config/) of the server config:

{{< example bom_modify_remove_tlp >}}

### Modifying Name or Version

If the document you are uploading has a different name or version than the data it shall modify, you need to provide that information to the BOMnipotent Client using command line arguments:

{{< example bom_modify_name >}}

BOMnipotent will infer the new data from the document you provide and change the database entries accordingly.

### Overwriting Name or Version (not recommended)

As with uploading, it is possible to overwrite the name and/or version stored in the local document:

{{< example bom_modify_overwrite_name >}}

**Important:** As with uploading, this modifies the JSON data before uploading to the server! The same caveats apply.

If the data on the server has a different name and/or version than specified in the document, you can combine the specification with an overwrite of the data:

{{< example bom_modify_overwrite_name_extreme >}}

Changing name and/or version without providing the complete document is not supported.


## Deleting

Deleting a BOM is very straightforward:

{{< example bom_delete >}}

If the BOM does not exist, the server will return 404 Not Found. If it does exists, it is removed from the database.

All components and vulnerabilities associated with the BOM are also deleted.
