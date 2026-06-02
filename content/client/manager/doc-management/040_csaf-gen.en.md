+++
title = "CSAF Generation"
slug = "csaf-gen"
weight = 40
description = "Learn how to generate CSAF documents with BOMnipotent, using only minimal input in TOML format."
+++

The [CSAF standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html) was designed to cover a plethora of use-cases. This makes it very powerful, but also very complex. In many cases, you, the vendor, merely want to quickly let your customers know that your product is (not) affected by a certain vulnerability.

Using a tool like [Secvisogram](/integration/secvisogram/), you can construct a full CSAF in each case, but this process is time-consuming.

Beginning with version 1.6.0, BOMnipotent supports generating CSAF document from a few lines of TOML input. It leverages the fact that the server already knows your setup, and makes some assumptions to fill in the blanks and create a valid CSAF document.

The input to communicate that your product is not affected by a vulnerability looks like this:

{{< file "csaf_input_not_affected.toml" >}}

- The "title" field is optional. If left out, BOMnipotent generates a title from the other input (see below).
- The "vuln" field needs to be the id of the vulnerability that the CSAF is about. While the CSAF standard allows to cover multiple vulnerabilities with a single document, BOMnipotent's generated algorithm is designed for exactly one, in order to reduce the complexity.
- The CSAF standard requires that a vulnerability has at least one "notes" entry. This is why the input requires "details". The information therein summarises the work of the security specialist who analysed the exploitability of the vulnerability in your product.
- The "tlp" field is optional, but recommended.
- The heart of a CSAF document is the connection between products and vulnerabilities. This is communicated via the "products" array. Each entry has the following fields:
  - The "name" and "version" need to correspond to the name and version of a BOM that you have [uploaded](/client/manager/doc-management/boms/#uploading) to your BOMnipotent Server.
  - The "status" needs to be one of [those](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3239-vulnerabilities-property---product-status) defined in the CSAF standard. You can communicate the most important information with "known_affected" and "known_not_affected".

  BOMnipotent uses this data to generate a "product_tree" of products mentioned in the input. This tree contains a layer for "vendor", for "product_name", and for "product_version". It furthermore creates the "vulnerabilities" entry of the CSAF, where each product is listed with its status.
- The publisher data of the CSAF document is taken from the [provider metadata](/server/configuration/required/provider-metadata/) that is required for the server setup.
- BOMnipotent assumes that the "status" of this CSAF document is "final", and that its "version" is "1.0.0". It sets the current timestamp as the "initial_release_date" as well as the "current_release_date", and creates the corresponding "revision_history".

{{< example "generate_csaf_not_affected" "1.6.0" >}}

{{< example "show_effect_not_affected" "1.6.0" >}}

{{< file "csaf_input_affected.toml" >}}

{{< example "generate_csaf_affected" "1.6.0" >}}

{{< example "show_effect_affected" "1.6.0" >}}

{{< file "csaf_input_globbing.toml" >}}

{{< example "generate_csaf_globbing" "1.6.0" >}}

{{< example "show_effect_globbing" "1.6.0" >}}

{{< file "csaf_input_minimal.toml" >}}

{{< example "generate_csaf_minimal" "1.6.0" >}}

{{< example "show_effect_minimal" "1.6.0" >}}
