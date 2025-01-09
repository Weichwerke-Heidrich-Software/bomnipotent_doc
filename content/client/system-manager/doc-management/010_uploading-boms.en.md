+++
title = "Uploading BOMs"
slug = "uploading-boms"
weight = 10
+++


> [BOMs for Consumers](/client/consumer/boms/) describes how to list and download the BOMs on the server.

> For BOM interactions beyond reading, you need the BOM_MANAGEMENT permission. The [User Management Section](/client/system-manager/user-management/) describes how it is granted.


To upload a BOM, call:
```bash
bomnipotent_client bom upload <path/to/bom>
```

BOMnipotent expects its BOMs in the structured [CycloneDX](https://cyclonedx.org/) JSON format.

> Consult the [Syft tutorial](/environment/syft) to learn how to generate a Bill of Materials (BOM) for your product.

The BOMnipotent Client will read the file at the provided path and upload its content. To add it to the database, it has to have some additional information: name, version, and possibly a TLP label. The identifiers name and version can either be inferred (recommended), or overwritten, as described below.

## Name and Version

{{< tabs >}}
{{% tab title="Inference (recommended)" %}}

BOMnipotent uses name and version to identify a BOM. It tries to infer these from the provided CycloneDX JSON fields metadata.component.name and metadata.component.version. However, according to the [CycloneDX specification](https://cyclonedx.org/docs/1.6/json/#metadata_component), the metadata.component field is optional.

If no version is specified, BOMnipotent instead uses the date of metadata.timestamp, if available.

To avoid any complications, it is recommended that you specify a name and version when generating the BOM, as is shown in the [Syft tutorial](/environment/syft).


{{% /tab %}}
{{% tab title="Overwriting (not particularly recommended)" %}}

If for some reason your BOM lacks a name or version, or if it is incorrect, the BOMnipotent Client offers to remedy that via command line arguments:
{{< tabs title="Upload" >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom upload <path/to/bom> --name-overwrite=<new-name> --version-overwrite=<new-version>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom upload <path/to/bom> -n <new-name> -v <new-version>
```
{{% /tab %}}
{{< /tabs >}}

**Important:** The BOMnipotent Client will in this case **modify the data** before sending it to the server. It does not modify the local file, as that would be overstepping. This means that your local file and the data on the server are now out-of-sync. What's maybe worse, if you signed your BOM, your signature is now invalid.

If you do use this option, it is thus recommended that you immediately download the BOM from the server (as described in [BOMs for Consumers](/client/consumer/boms/)) and replace your local file with the result.


{{% /tab %}}
{{< /tabs >}}

## TLP Classification

For consumers, BOMnipotent manages access to data using the [Traffic Light Protocol (TLP)](https://www.first.org/tlp/). The
[CycloneDX Format](https://cyclonedx.org/) on the other hand does not currently support document classification.

To tell BOMnipotent how to classify a document, you have two options:
1. Set a default TLP Label in the [server config](/server/configuration/default-tlp/). This will then be used for all BOMs without further specifications.
2. Provide a tlp classification via command line argument:
{{< tabs title="Upload" >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom upload <path/to/bom> --tlp=<label>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom upload <path/to/bom> -t <label>
```
{{% /tab %}}
{{< /tabs >}}

If you do neither, BOMnipotent will treat any unclassified documents as if they were labelled {{< tlp-red >}}, and will log a warning every time it has to do that.
