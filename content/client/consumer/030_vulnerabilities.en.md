+++
title = "Vulnerabilities"
slug = "vulnerabilities"
weight = 30
description = "Learn how to list known vulnerabilities affecting a product using BOMnipotent Client and understand the output details, including CVSS, TLP, and CSAF."
+++

## List

To dispaly a list of known vulnerabilities accessible to you, call:

{{< example vuln_list >}}

The output contains an ID for the vulnerability, a description, and a [CVSS value](https://www.first.org/cvss/) and/or severity if available. It also contains a [TLP Classification](https://www.first.org/tlp/) derived from that of the affected product, and ideally a [CSAF Assessment](https://www.csaf.io/) by the vendor.

The list can be filtered by name and/or version of the affected product:

{{< example vuln_filtered_list >}}

To display only those vulnerabilities that are not yet covered by a CSAF advisory, call:

{{< example vuln_list_unassessed >}}

The behaviour here is special: If there are any unassessed vulnerabilities, the client will return an error code. This is meant to ease the integration with scripts that regularly check for new vulnerabilities, as is for example described in the [section about CI/CD](/integration/ci-cd/).

Listing only vulnerabilities that have an advisory is also possible, but does not exhibit any special client behaviour:

{{< example vuln_list_unassessed_false >}}

The CSAF document is a crucial part of vulnerability handling, because it tells you, the user of the product, how you should react to this supply chain vulnerability. Read the [next section](/client/consumer/csaf-docs/) to find out how to access them.

## Existence

{{< exist-subcommand-en >}}

{{< example vuln_exist >}}
