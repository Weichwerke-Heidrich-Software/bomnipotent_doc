+++
title = "BOMs"
slug = "boms"
weight = 10
description = "Learn how to manage Bills of Materials (BOMs) with BOMnipotent, including uploading, modifying, and deleting."
+++

Bills of Materials stand at the forefront of both BOMnipotents functionality and name. A BOM is a list of all components that make up a product. In the context of cybersecurity, the most prominent variant is the Software Bill of Materials (SBOM), but BOMs allow for more general considerations as well.

> For BOM interactions beyond reading, you need the BOM_MANAGEMENT permission. The section about [Access Management](/client/manager/access-management/) describes how it is granted.

## Uploading

To upload a BOM, call:
```
bomnipotent_client bom upload <PATH/TO/BOM>
```

BOMnipotent expects its BOMs in the structured [CycloneDX](https://cyclonedx.org/) JSON format.

> Consult the [Syft tutorial](/integration/syft) to learn how to generate a BOM for your product.

The BOMnipotent Client will read the file at the provided path and upload its content. It can then be viewed by the consumers with appropriate permissions.

> [BOMs for Consumers](/client/consumer/boms/) describes how to list and download the BOMs on the server.

To add a BOM to the database, the BOMnipotent Client has to have some additional information: a name, a version, and optionally a TLP label. The identifiers name and version can either be inferred (recommended), or overwritten, as described below.

### Name and Version

{{< tabs >}}
{{% tab title="Inference (recommended)" %}}

BOMnipotent uses name and version to identify a BOM. It tries to infer these from the provided CycloneDX JSON fields "metadata.component.name" and "metadata.component.version". However, according to the [CycloneDX specification](https://cyclonedx.org/docs/1.6/json/#metadata_component), the metadata.component field is optional.

If no version is specified, BOMnipotent instead uses the date of "metadata.timestamp", if available.

To avoid any complications, it is recommended that you specify a name and version when generating the BOM, as is shown in the [Syft tutorial](/integration/syft).

{{% /tab %}}
{{% tab title="Overwriting (not particularly recommended)" %}}

If for some reason your BOM lacks a name or version, or if it is incorrect, the BOMnipotent Client offers to remedy that via command line arguments:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom upload <PATH/TO/BOM> --name-overwrite=<NEW-NAME> --version-overwrite=<NEW-VERSION>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom upload <PATH/TO/BOM> -n <NEW-NAME> -v <NEW-VERSION>
```
{{% /tab %}}
{{< /tabs >}}

**Important:** The BOMnipotent Client will in this case **modify the data** before sending it to the server. It does not modify the local file, as that would be overstepping. This means that your local file and the data on the server are now out-of-sync. What's maybe worse, if you signed your BOM, your signature is now invalid.

If you do use this option, it is thus recommended that you immediately download the BOM from the server (as described in [BOMs for Consumers](/client/consumer/boms/)) and replace your local file with the result.

{{% /tab %}}
{{< /tabs >}}

### TLP Classification

For consumers, BOMnipotent manages access to data using the [Traffic Light Protocol (TLP)](https://www.first.org/tlp/). The
[CycloneDX Format](https://cyclonedx.org/) on the other hand does not currently support document classification.

To tell BOMnipotent how to classify a document, you have two options:
1. Set a [default TLP Label](/server/configuration/optional/tlp-config/) in the server config. This will then be used for all BOMs without further specifications.
2. Provide a tlp classification via command line argument:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom upload <PATH/TO/BOM> --tlp=<LABEL>
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client bom upload <PATH/TO/BOM> -t <LABEL>
```
{{% /tab %}}
{{< /tabs >}}

If you do neither, BOMnipotent will treat any unclassified documents as if they were labelled {{< tlp-red >}}, and will log a warning every time it has to do that.


## Modifying

In the simplest case, modifying an existing BOM works very much like uploading a new one.
```
bomnipotent_client bom modify <PATH/TO/BOM>
```

This will infer the name and version from the document, and overwrite the existing content on the server. If the data does not exist on the server, it will return a 404 Not Found error.

### Modifying TLP Label

If a TLP label had previously been assigned to the BOM, a modification of the contents will **not** automatically alter it.

If you want to specify a new TLP label, you can do so via argument:

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> --tlp=<LABEL>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> -t <LABEL>
```
{{% /tab %}}
{{< /tabs >}}

If the contents of the BOM have not changed and you just want to modify the TLP label, you do not need to upload the document again. Instead of providing a path to a file, you can specify name and version of the BOM you want to reclassify:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom modify --name=<NAME> --version=<VERSION> --tlp=<LABEL>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom modify -n <name> -v <version> -t <label>
```
{{% /tab %}}
{{< /tabs >}}

If you specify "none", "default" or "unlabelled" as the TLP label, any existing classification will be removed, and the server falls back to the [default TLP Label](/server/configuration/optional/tlp-config/) of the server config:

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> --tlp=none
bomnipotent_client bom modify <PATH/TO/BOM> --tlp=default # Does the same
bomnipotent_client bom modify <PATH/TO/BOM> --tlp=unlabelled # Does the same
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> -t none
bomnipotent_client bom modify <PATH/TO/BOM> -t default # Does the same
bomnipotent_client bom modify <PATH/TO/BOM> -t unlabelled # Does the same
```
{{% /tab %}}
{{< /tabs >}}

### Modifying Name or Version

If the document you are uploading has a different name or version than the data it shall modify, you need to provide that information to the BOMnipotent Client using command line arguments:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> --name=<OLD-NAME> --version=<OLD-VERSION>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> -n <OLD-NAME> -v <OLD-VERSION>
```
{{% /tab %}}
{{< /tabs >}}

BOMnipotent will infer the new data from the document you provide and change the database entries accordingly.

### Overwriting Name or Version (not recommended)

As with uploading, it is possible to overwrite the name and/or version stored in the local document:

```
bomnipotent_client bom modify <PATH/TO/BOM> --name-overwrite=<NEW-NAME> --version-overwrite=<NEW-VERSION>
```

**Important:** As with uploading, this modifies the JSON data before uploading to the server! The same caveats apply.

If the data on the server has a different name and/or version than specified in the document, you can combine the specification with an overwrite of the data:

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> --name=<OLD-NAME> --version=<OLD-VERSION> --name-overwrite=<NEW-NAME> --version-overwrite=<NEW-VERSION>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom modify <PATH/TO/BOM> -n <OLD-NAME> -v <OLD-VERSION> --name-overwrite=<NEW-NAME> --version-overwrite=<NEW-VERSION>
```
{{% /tab %}}
{{< /tabs >}}

Changing name and/or version without providing the complete document is not supported.


## Deleting

Deleting a BOM is very straightforward:
```
bomnipotent_client bom delete <NAME> <VERSION>
```

If the BOM does not exist, the server will return 404 Not Found. If it does exists, it is removed from the database.
