+++
title = "CSAF Documents"
slug = "csaf-docs"
weight = 40
description = "Learn how to list and download CSAF documents using BOMnipotent Client, including commands and output examples, and understand the file naming scheme."
+++

When a vulnerability becomes known in one of the components of a product that you use, one of the most natural questions to ask is "What do I have to do now?". The [Common Security Advisory Format (CSAF)](https://www.csaf.io/) aims to provide an answer to that question in an automated fashion. It is a mainly machine-readable format for exchanging advisories about security vulnerabilities.

One of the main functionalities of BOMnipotent is to make distribution of CSAF documents as easy as possible. Any running instance of BOMnipotent Server acts as a "CSAF Provider" according to the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider).

## List

Running

```bash
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

## Download

To locally mirror all CSAF documents accessible to you, run
```bash
bomnipotent_client csaf download ./csaf
```
``` {wrap="false" title="output"}
[INFO] Storing CSAF documents under ./csaf
```

This will store th CSAF documents in the provided folder ("./csaf", in this example). It will create the folder structure if it does not already exist. The CSAF documents are stored in file paths following the naming scheme `{tlp}/{initial_release_year}/{csaf_id}.json`. 

> The filenames of CSAF documents follow a naming scheme defined by the [OASIS standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#51-filename): The ids are converted into lowercase, and most special characters are replaced by an underscore '_'. This means that, in principle, different CSAF documents could lead to the same filepath. In that case, BOMnipotent will display an error instead of silently overwriting a file.


```bash
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

```bash
bomnipotent_client csaf download ./csaf white/2022/bsi-2022-0001.json
```

## Get

You can directly display the contents of a single CSAF doc to the consolte output by calling
```bash
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
