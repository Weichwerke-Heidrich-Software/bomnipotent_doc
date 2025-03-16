+++
title = "CSAF Documents"
slug = "csaf-docs"
weight = 30
description = "Learn how to manage CSAF documents with BOMnipotent Client, including uploading, modifying, and deleting security advisories."
+++

A Common Security Advisory Format (CSAF) document is a vendor's response to a newly discovered vulnerability. It is a machine-readable format to spread information on how a user of your product should react: Do they need to update to a newer version? Do they need to modify a configuration? Is your product even truly affected, or does it maybe never call the affected part of the vulnerable library?

> For CSAF interactions beyond reading, you need the CSAF_MANAGEMENT permission. The [User Management Section](/client/manager/user-management/) describes how it is granted.

## Uploading

To upload a CSAF document, call
```bash
bomnipotent_client csaf upload <PATH/TO/CSAF>
```

``` {wrap="false" title="output"}
[INFO] Uploaded CSAF with id WID-SEC-W-2024-3470
```

Before your CSAF document is uploaded, BOMnipotent Client checks that it is valid according to the [OASIS CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#61-mandatory-tests).

You can view the result of the operation with
```bash
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

```bash
bomnipotent_client csaf delete <CSAF-ID> <PATH/TO/CSAF>
```
``` {wrap="false" title="output"}
[INFO] Modified CSAF with id BSI-2024-0001-unlabeled
```

The command requires the ID of the hosted CSAF document, because it can in principle modify that as well. The new CSAF document is considered authorative.

## Deleting

To delete a CSAF document from your server (which you should really only do if something went completely wrong), simply call:
```bash
bomnipotent_client csaf delete <CSAF-ID>
```
``` {wrap="false" title="output"}
[INFO] Deleted CSAF with id WID-SEC-W-2024-3470
```
