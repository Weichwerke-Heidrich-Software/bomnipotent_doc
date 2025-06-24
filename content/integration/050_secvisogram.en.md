+++
title = "CSAF Docs with Secvisogram"
slug = "secvisogram"
weight = 50
+++

The [Common Security Advisory Framework](https://www.csaf.io/specification.html) (CSAF) is a machine-readable format and international standard for sharing information about cybersecurity vulnerabilities. Its purpose is to inform users of your product how they should react: Do they need to update to a newer version? Do they need to modify a configuration? Is your product even truly affected, or does it maybe never call the affected part of the vulnerable library?

The [CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html) by OASIS Open aims to cover a wide range of scenarios. As such, it can be very overwhelming at first. This page serves to highlight the key components a CSAF document requires and offer a practical guide to get started right away.

## Secvisogram

CSAF documents are files in JSON format following a specific schema. As such, they can in principle be created with any text editor. However, CSAF documents need to adhere to a large set of rules which any CSAF provider (and that includes BOMnipotent) needs to check.

Instead, it is recommended to use [Secvisogram](https://github.com/secvisogram/secvisogram). It is an open-source server application with a graphical user interface, originally developed by the German Bundesamt für Sicherheit in der Informationstechnik (BSI).

### Local Editor

Probably the most comfortable way to get started with writing CSAF documents is to fork the [local_csaf_editor](https://github.com/aunovis/local_csaf_editor) repository by [AUNOVIS GmbH](https://www.aunovis.de/). It contains a small bash script to locally clone and run Secvisogram, and it encourages you to store versioned CSAF templates.

## Important Entries

TODO

### Important Document Properties

TODO

### Important Branch Properties

TODO

### Important Vulnerabilities Properties

TODO
