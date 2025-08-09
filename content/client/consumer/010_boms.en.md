+++
title = "BOMs"
slug = "boms"
weight = 10
description = "Learn about Bills of Materials (BOMs) in cybersecurity, how to list and download them using the BOMnipotent Client, and file storage details."
+++

Bills of Materials stand at the forefront of both BOMnipotents functionality and name. A BOM is a list of all components that make up a product. In the context of cybersecurity, the most prominent variant is the Software Bill of Materials (SBOM), but BOMs allow for more general considerations as well.

## List

Running the following command will list all BOMs accessible to you:

{{< example bom_list >}}

BOMs with label {{<tlp-white>}} / {{<tlp-clear>}} are visible to everyone. In this example, your account has access to one BOM with label {{<tlp-amber>}}.

The command accepts the optional filters "name" and "version":

{{< example bom_filtered_list >}}

## Download

To create a local copy of all boms the server exposes to you, run:

{{< example bom_download >}}

This will store the BOMs in the provided folder ("./boms", in this example). It will create the folder structure if it does not already exist. The BOMs are stored in files following the naming scheme `{product name}_{product version}.cdx.json`.

> To avoid inconsistent behaviour accross operating systems, the name and version of the product are converted into lowercase, and most special characters are replaced by an underscore '_'. This means that, in principle, different products could lead to the same filename. In that case, BOMnipotent will display a warning instead of silently overwriting a file.

The client also downloads several files containing a hash and the filename of the hashed file.

{{< example tree_boms >}}

Before requesting files for download, BOMnipotent Client makes an inventory of the BOMs already present in the folder, and downloads only the missing ones.

BOMnipotent **does not** automatically replace existing files, even if they have changed on the server. It instead prints a warning message:

{{< example bom_download_warn >}}

You can tell BOMnipotent that you really want this file overwritten by using the "--overwrite" flag:

{{< example bom_download_overwrite >}}

Analogously to the [list](#list) command, the download command accepts the filters "name" and "version", to only download a subset of BOMs:

{{< example bom_filtered_download >}}

## Get

You can directly display the contents of a single BOM to the console output by calling

{{< example bom_get >}}

This is especially useful if you want to use the contents of this BOM in a script. For example, to [check for vulnerabilities](/integration/grype/) in the supply chain, you could call:

{{< example bom_get_grype >}}

## Existence

{{< exist-subcommand-en >}}

{{< example bom_exist >}}
