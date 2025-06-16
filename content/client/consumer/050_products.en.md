+++
title = "Products"
slug = "products"
weight = 50
description = "Listing of products covered by a CSAF advisory, including product names, vulnerabilities, statuses, CSAF IDs, and TLP levels, with command to generate the list."
+++

## List

To see exactly which products are covered by which CSAF advisory, run:

{{< example product_list >}}

The command accepts the optional filters "name", "vulnerability", "status" and "csaf":

{{< example product_filtered_list >}}

## Existence

{{< exists-subcommand-en >}}

{{< example product_exists >}}
