+++
title = "Components"
slug = "bom-components"
weight = 20
description = "Learn how to use BOMnipotent Client to list all components of a product, including their names, versions, types, CPEs, and PURLs, with example commands."
+++

The purpose of a Bill of Materials is to catalogue components of a product. BOMnipotent Client can be used to list all packages etc. contained in any product that is accessible to your user account. Simply call the client with the arguments "component", "list", and then name and version of the product:

{{< example component_list >}}

The command accepts the optional filters "name", "version", "type", "cpe" and "purl" (not all used here for the sake of breviy):

{{< example component_filtered_list >}}

This output is primarily meant to be human-readable. Using the `--output=raw` option makes it machine-readable in principle, but [downloading the complete BOM](/client/consumer/boms/) is most likely preferable to parsing this table output.

A vendor of a product should periodically scan the BOM of a product for vulnerabilities, for example by using tools like [grype](/integration/grype/). The [next section](/client/consumer/vulnerabilities/) explains how you as the user of a product can access these list.
