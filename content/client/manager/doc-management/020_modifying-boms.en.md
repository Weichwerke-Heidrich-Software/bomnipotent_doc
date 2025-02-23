+++
title = "Modifying BOMs"
slug = "modifying-boms"
weight = 20
+++

> For BOM interactions beyond reading, you need the BOM_MANAGEMENT permission. The [User Management Section](/client/manager/user-management/) describes how it is granted.

In the simplest case, modifying an existing BOM works very much like uploading a new one.
```bash
bomnipotent_client bom modify <path/to/bom>
```

This will infer the name and version from the document, and overwrite the existing content on the server. If the data does not exist on the server, it will return a 404 Not Found error.

## Modifying TLP Label

If a TLP label had previously been assigned to the BOM, a modification of the contents will **not** automatically alter it.

If you want to specify a new TLP label, you can do so via argument:

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom modify <path/to/bom> --tlp=<label>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom modify <path/to/bom> -t <label>
```
{{% /tab %}}
{{< /tabs >}}

If the contents of the document have not changed, you do not need to upload it again. Instead of providing a path to a file, you can specify name and version of the BOM you want to reclassify in that case:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom modify --name=<name> --version=<version> --tlp=<label>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom modify -n <name> -v <version> -t <label>
```
{{% /tab %}}
{{< /tabs >}}

If you specify "none" or "default" as the TLP label, any existing classification will be removed, and the server falls back to the default TLP of the [server config](/server/configuration/default-tlp/):

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom modify <path/to/bom> --tlp=none
bomnipotent_client bom modify <path/to/bom> --tlp=default # Does the same
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom modify <path/to/bom> -t none
bomnipotent_client bom modify <path/to/bom> -t default # Does the same
```
{{% /tab %}}
{{< /tabs >}}

## Modifying Name or Version

If the document you are uploading has a different name or version than the data it shall modify, you need to provide that information to the BOMnipotent Client using command line arguments:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom modify <path/to/bom> --name=<old-name> --version=<old-version>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom modify <path/to/bom> -n <old-name> -v <old-version>
```
{{% /tab %}}
{{< /tabs >}}

BOMnipotent will infer the new data from the document you provide and change the database entries accordingly.

## Overwriting Name or Version (not recommended)

As with uploading, it is possible to overwrite the name and/or version stored in the local document:

```bash
bomnipotent_client bom modify <path/to/bom> --name-overwrite=<new-name> --version-overwrite=<new-version>
```

**Important:** As with uploading, this modifies the JSON data before uploading to the server! The same caveats apply.

If the data on the server has a different name and/or version, you can combine the specification with an overwrite of the data:

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom modify <path/to/bom> --name=<old-name> --version=<old-version> --name-overwrite=<new-name> --version-overwrite=<new-version>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom modify <path/to/bom> -n <old-name> -v <old-version> --name-overwrite=<new-name> --version-overwrite=<new-version>
```
{{% /tab %}}
{{< /tabs >}}

Changing name and/or version without providing the complete document is not supported.
