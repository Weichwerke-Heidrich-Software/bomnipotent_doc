+++
title = "CSAF Documents"
slug = "csaf-docs"
weight = 40
description = "Learn how to list and download CSAF documents using BOMnipotent Client, including commands and output examples, and understand the file naming scheme."
+++

When a vulnerability becomes known in one of the components of a product that you use, one of the most natural questions to ask is "What do I have to do now?". The [Common Security Advisory Framework (CSAF)](https://www.csaf.io/) aims to provide an answer to that question in an automated fashion. It is a mainly machine-readable format for exchanging advisories about security vulnerabilities.

One of the main functionalities of BOMnipotent is to make distribution of CSAF documents as easy as possible. Any running instance of BOMnipotent Server acts as a "CSAF Provider" according to the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider).

## List

Running the following command will give you a list of all CSAF documents accessible to you:

{{< example csaf_list >}}

Accesible CSAF documents are those that are either labeled {{<tlp-white>}}/{{<tlp-clear>}}, or that concern a product that you have been granted access to.

### Filter

The "csaf list" command allows quite a large number of filters, to display only some of all CSAF documents:
- *id*: The ID of a CSAF document is unique, so this filter will display at most one result.
- *filename*: According to the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename), CSAF IDs allow more characters than filenames. Thus, a CSAF doc's filename is not necessarily unique.
- *before*: Show only CSAF documents that were initially released before a certain datetime. The input can be of the forms "YYYY", "YYYY-MM", "YYYY-MM-DD", "YYYY-MM-DD HH", "YYYY-MM-DD HH:MM" or "YYYY-MM-DD HH:MM:SS". If the input is less precise than seconds, it is assumend to be *minimal*. This means that "before 2025-08" filters for documents that were released before 2025-08-01 00:00:00. UTC is assumed as the timezone, unless you explicitly specify another one by adding an offset ("+02:00" for example) to the input.
- *after*: Show only CSAF documents that were initially released after a certain datetime. If the input is less precise than seconds, it is assumed to be *maximal*. This means that "after 2025-08" filters for documents that were release after 2025-08-31 13:59:59.
- *year*: Show only CSAF documents that were initially released within a given year.
- *status*: Filter by document status. The [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#321127-document-property---tracking---status) lists all allowed values.
- *tlp*: Show only CSAF document with a certain [TLP](https://www.first.org/tlp/) classification. In addition to the labels of TLP1 and TLP2, "default", "none", "unclassified" and "unlabeled" are valid inputs here (all denoting the same thing).

{{< example csaf_filtered_list >}}

{{< example csaf_filtered_list_time_precision >}}

## Download

To locally mirror all CSAF documents accessible to you, run

{{< example csaf_download >}}

This will store the CSAF documents in the provided folder ("/home/csaf", in this example). It will create the folder structure if it does not already exist. The CSAF documents are stored in file paths following the naming scheme "{tlp}/{initial_release_year}/{csaf_id}.json".

Beginning with version 1.3.0, an arbitrary Server acting as a [CSAF provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider) can be used as an endpoint.

{{< example "csaf_download_other" "1.3.0" >}}

The CSAF standard makes several suggestions where the provider metadata should be hosted, and how it can be found. However, some providers still decide to host it somewhere else. To make interaction with these possible as well, the provider metadata URL can be explicitly provided as an argument:

{{< example "csaf_download_metadata" "1.4.0" >}}

This skips any further lookups, effectively ignoring the "--domain" argument.

> The filenames of CSAF documents follow a naming scheme defined by the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename): The ids are converted into lowercase, and most special characters are replaced by an underscore '_'. This means that, in principle, different CSAF documents could lead to the same filepath. In that case, BOMnipotent will display an error instead of silently overwriting a file.

The client also downloads several files containing a hash and the filename of the hashed file.

If [OpenPGP](/server/configuration/optional/open-pgp/) is configured on the server, the client furthermore downloads cryptografic signatures for the CSAF documents. They are saved in ".json.asc" files, and can for example be verified using [Sequoia-PGP](/integration/open-pgp/).

{{< example tree_csaf >}}

Before requesting files for download, BOMnipotent Client makes an inventory of the CSAF documents already present in the folder, and downloads only the missing ones.

It is possible to only download a single file by providing the path as an additional argument:

{{< example csaf_download_single >}}

BOMnipotent **does not** automatically replace existing files, even if they have changed on the server. It instead prints a warning message:

{{< example csaf_download_warn >}}

You can tell BOMnipotent that you really want this file overwritten by using the "overwrite" flag:

{{< example csaf_download_overwrite >}}

The download command accepts exactly the [same filters](#filter) as the list command does, allowing to only download those documents that are relevant to you.

## Get

You can directly display the contents of a single CSAF doc to the consolte output by calling

{{< example csaf_get >}}

This is especially useful if you want to use the contents of this CSAF doc in a script.

## Existence

{{< exist-subcommand-en >}}

{{< example csaf_exist >}}

## Match

To find out if the server hosts any BOM documents containing components that are affected by locally available advisories, you can call the "csaf match" command and provide one or more paths to CSAF documents. BOMnipotent then requests all accessible BOM documents from the server and matches their components against all provided CSAF documents:

{{< example "csaf_match" "1.2.0" >}}

## Analyze

Running the command "csaf analyze" and providing it with one or more filepaths to valid CSAF files displays the metadata of these documents:

{{< example "csaf_analyze" "1.2.0" >}}

The command runs a full [validity check](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests) on the CSAF document and can therefore also be used to detect deviations from the standard:

{{< example "csaf_analyze_invalid" "1.2.0" >}}
