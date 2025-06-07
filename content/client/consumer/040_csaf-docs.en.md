+++
title = "CSAF Documents"
slug = "csaf-docs"
weight = 40
description = "Learn how to list and download CSAF documents using BOMnipotent Client, including commands and output examples, and understand the file naming scheme."
+++

When a vulnerability becomes known in one of the components of a product that you use, one of the most natural questions to ask is "What do I have to do now?". The [Common Security Advisory Framework (CSAF)](https://www.csaf.io/) aims to provide an answer to that question in an automated fashion. It is a mainly machine-readable format for exchanging advisories about security vulnerabilities.

One of the main functionalities of BOMnipotent is to make distribution of CSAF documents as easy as possible. Any running instance of BOMnipotent Server acts as a "CSAF Provider" according to the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider).

## List

Running

```
./bomnipotent_client csaf list
```

will give you a list of all CSAF documents accessible to you.

``` {wrap="false" title="output"}
╭───────────────┬───────────────────────────┬──────────────────────┬──────────────────────┬────────┬───────────╮
│ ID            │ Title                     │ Initial Release      │ Current Release      │ Status │ TLP       │
├───────────────┼───────────────────────────┼──────────────────────┼──────────────────────┼────────┼───────────┤
│ BSI-2022-0001 │ CVRF-CSAF-Converter: XML  │ 2022-03-17 13:03 UTC │ 2022-07-14 08:20 UTC │ final  │ TLP:WHITE │
│               │ External Entities Vulnera │                      │                      │        │           │
│               │ bility                    │                      │                      │        │           │
╰───────────────┴───────────────────────────┴──────────────────────┴──────────────────────┴────────┴───────────╯
```

Accesible CSAF documents are those that are either labeled {{<tlp-white>}}/{{<tlp-clear>}}, or that concern a product that you have been granted access to.

### Filtering

The "csaf list" command allows quite a large number of filters, to display only some of all CSAF documents:
- *id*: The ID of a CSAF document is unique, so this filter will display at most one result.
- *filename*: According to the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename), CSAF IDs allow more characters than filenames. Thus, a CSAF doc's filename is not necessarily unique.
- *after*: Show only CSAF documents that were initially released after a certain datetime. The input should be in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339) format, including date, time, and timezone.
- *before*: Show only CSAF documents that were initially released before a certain datetime.
- *year*: Show only CSAF documents that were initially released within a given year.
- *status*: Filter by document status. The [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#321127-document-property---tracking---status) lists all allowed values.
- *tlp*: Show only CSAF document with a certain [TLP](https://www.first.org/tlp/) classification. In addition to the labels of TLP1 and TLP2, "default", "none", "unclassified" and "unlabeled" are valid inputs here (all denoting the same thing).

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client csaf list --after=2023-07-01T00:00Z --year=2023 --status=final --tlp=amber
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client csaf list -a 2023-07-01T00:00Z -y 2023 -s final -t amber
```
{{% /tab %}}
{{< /tabs >}}

## Download

To locally mirror all CSAF documents accessible to you, run
```
bomnipotent_client csaf download ./csaf
```
``` {wrap="false" title="output"}
[INFO] Storing CSAF documents under ./csaf
```

This will store th CSAF documents in the provided folder ("./csaf", in this example). It will create the folder structure if it does not already exist. The CSAF documents are stored in file paths following the naming scheme "{tlp}/{initial_release_year}/{csaf_id}.json".

> The filenames of CSAF documents follow a naming scheme defined by the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename): The ids are converted into lowercase, and most special characters are replaced by an underscore '_'. This means that, in principle, different CSAF documents could lead to the same filepath. In that case, BOMnipotent will display an error instead of silently overwriting a file.


```
tree ./csaf/
```

``` {wrap="false" title="output"}
./csaf/
└── white
    └── 2022
        └── bsi-2022-0001.json
```

Before requesting files for download, BOMnipotent Client makes an inventory of the CSAF documents already present in the folder, and downloads only the missing ones.

It is possible to only download a single file by providing the path as an additional argument:

```
bomnipotent_client csaf download ./csaf white/2022/bsi-2022-0001.json
```

BOMnipotent **does not** automatically replace existing files, even if they have changed on the server. It instead prints a warning message:
``` {wrap="false" title="output"}
[WARN] File ./csaf/white/2023/wid-sec-w-2023-0001.json already exists.
Use the "--overwrite" flag to replace it.
Skipping download to prevent data loss.
```

You can tell BOMnipotent that you really want this file overwritten by using the "--overwrite" flag:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client csaf download ./csaf --overwrite
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client csaf download ./csaf -o
```
{{% /tab %}}
{{< /tabs >}}

The download command accepts exactly the [same filters](#filtering) as the list command does, allowing to only download those documents that are relevant to you.

## Get

You can directly display the contents of a single CSAF doc to the consolte output by calling
```
bomnipotent_client csaf get <ID>
```
``` {wrap="false" title="output (cropped)"}
{
  "document" : {
    "aggregate_severity" : {
      "text" : "mittel"
    },
    "category" : "csaf_base",
    "csaf_version" : "2.0",
    "distribution" : {
      "tlp" : {
        "label" : "WHITE",
...
```

This is especially useful if you want to use the contents of this CSAF doc in a script.
