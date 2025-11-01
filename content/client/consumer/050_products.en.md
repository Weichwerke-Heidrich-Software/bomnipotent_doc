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

{{< exist-subcommand-en >}}

{{< example product_exist >}}

## Analyze

Running the command "product analyze" and providing it with one or more filepaths to valid CSAF files displays the (combined) products covered by these documents:

{{< example "product_analyze" "1.2.0" >}}
