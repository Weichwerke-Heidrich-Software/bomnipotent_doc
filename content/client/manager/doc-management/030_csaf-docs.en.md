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

{{< example csaf_upload >}}

Before your CSAF document is uploaded, BOMnipotent Client checks that it is valid according to the [OASIS CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests).

### Conflict Handling

CSAF documents are identified by their, well, identifier, which needs to be unique. Trying to upload another document with the same id results in an error:

{{< example csaf_upload_err_on_existing >}}

You can override this behaviour with the "on-existing" option, telling BOMnipotent to either skip or replace conflicting documents:

{{< example csaf_upload_skip_existing >}}

{{< example csaf_upload_replace_existing >}}

## Listing

You can view the result of the operation with

{{< example csaf_list >}}

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

{{< example csaf_modify >}}

The command can even modify the ID of the CSAF document. Because the old ID cannot be inferred from the new document in that case, it has to be provided as an optional argument:

{{< example csaf_modify_id >}}

## Deleting

To delete a CSAF document from your server (which you should really only do if something went completely wrong), simply call:

{{< example csaf_delete >}}
