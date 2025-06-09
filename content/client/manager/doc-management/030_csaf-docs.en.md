+++
title = "CSAF Documents"
slug = "csaf-docs"
weight = 30
description = "Learn how to manage CSAF documents with BOMnipotent Client, including uploading, modifying, and deleting security advisories."
+++

A [Common Security Advisory Framework](https://www.csaf.io/) (CSAF) document is a vendor's response to a newly discovered vulnerability. It is a machine-readable format to spread information on how a user of your product should react: Do they need to update to a newer version? Do they need to modify a configuration? Is your product even truly affected, or does it maybe never call the affected part of the vulnerable library?

> For CSAF interactions beyond reading, you need the {{<csaf-management-en>}} permission. The sectino about [Access Management](/client/manager/access-management/) describes how it is granted.

## Uploading

To upload a CSAF document, call
```
bomnipotent_client csaf upload <PATH/TO/CSAF>
```

``` {wrap="false" title="output"}
[INFO] Uploaded CSAF with id WID-SEC-W-2024-3470
```

Before your CSAF document is uploaded, BOMnipotent Client checks that it is valid according to the [OASIS CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests).

CSAF documents are identified by their, well, identifier, which needs to be unique. Trying to upload another document with the same id results in an error. You can override this behaviour with the "on-existing" option, telling BOMnipotent to either skip or replace conflicting documents:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client csaf upload <PATH/TO/CSAF> --on-existing=skip
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client csaf upload <PATH/TO/CSAF> -o skip
```
{{% /tab %}}
{{< /tabs >}}


{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client csaf upload <PATH/TO/CSAF> --on-existing=replace
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client csaf upload <PATH/TO/CSAF> -o replace
```
{{% /tab %}}
{{< /tabs >}}

## Listing

You can view the result of the operation with
```
bomnipotent_client csaf list
```
``` {wrap="false" title="output"}
╭─────────────────────┬───────────────────────────┬─────────────────────────┬─────────────────────────┬────────┬───────────╮
│ ID                  │ Title                     │ Initial Release         │ Current Release         │ Status │ TLP       │
├─────────────────────┼───────────────────────────┼─────────────────────────┼─────────────────────────┼────────┼───────────┤
│ WID-SEC-W-2024-3470 │ binutils: Schwachstelle e │ 2024-11-14 23:00:00 UTC │ 2024-11-17 23:00:00 UTC │ final  │ TLP:WHITE │
│                     │ rmöglicht Denial of Servi │                         │                         │        │           │
│                     │ ce                        │                         │                         │        │           │
╰─────────────────────┴───────────────────────────┴─────────────────────────┴─────────────────────────┴────────┴───────────╯
```

All data is taken from the CSAF document.

If the document does not have the optional TLP label entry, it is treated with the [default tlp](/server/configuration/optional/tlp-config/) configured for the server.


``` {wrap="false" title="output"}
...┬────────┬─────────╮
...│ Status │ TLP     │
...┼────────┼─────────┤
...│ final  │ Default │
...┴────────┴─────────╯
```


## Modifying

When the status of your document changes, if you want to reclassify it, or if new information has come to light, you may want to modify your document. To upload the new version, call:

```
bomnipotent_client csaf delete <PATH/TO/CSAF>
```
``` {wrap="false" title="output"}
[INFO] Modified CSAF with id BSI-2024-0001-unlabeled
```

The command can even modify the ID of the CSAF document. Because the old ID cannot be inferred from the new document in that case, it has to be provided as an optional argument:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client csaf delete <PATH/TO/CSAF> --id=<OLD-ID>
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client csaf delete <PATH/TO/CSAF> -i <OLD-ID>
```
{{% /tab %}}
{{< /tabs >}}


## Deleting

To delete a CSAF document from your server (which you should really only do if something went completely wrong), simply call:
```
bomnipotent_client csaf delete <CSAF-ID>
```
``` {wrap="false" title="output"}
[INFO] Deleted CSAF with id WID-SEC-W-2024-3470
```
