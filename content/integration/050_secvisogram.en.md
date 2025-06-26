+++
title = "CSAF Docs with Secvisogram"
slug = "secvisogram"
weight = 50
+++

The [Common Security Advisory Framework](https://www.csaf.io/specification.html) (CSAF) is a machine-readable format and international standard for sharing information about cybersecurity vulnerabilities. Its purpose is to inform users of your product how they should react: Do they need to update to a newer version? Do they need to modify a configuration? Is your product even truly affected, or does it maybe never call the affected part of the vulnerable library?

The [CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html) by OASIS Open aims to cover a very wide range of scenarios. As such, it can be very overwhelming at first. This page serves to highlight the key components a CSAF document requires, and to offer a practical guide to get started right away.

## Secvisogram

CSAF documents are files in JSON format following a specific schema. As such, they can in principle be created with any text editor. However, CSAF documents need to adhere to a large set of rules which any CSAF provider (and that includes BOMnipotent) needs to check.

Instead, it is recommended to use [Secvisogram](https://github.com/secvisogram/secvisogram). It is an open-source server application with a graphical user interface, originally developed by the German Bundesamt für Sicherheit in der Informationstechnik (BSI).

### Local Editor

Probably the most comfortable way to get started with writing CSAF documents is to fork the [local_csaf_editor](https://github.com/aunovis/local_csaf_editor) repository by [AUNOVIS GmbH](https://www.aunovis.de/). It contains a small bash script to locally clone and run Secvisogram. It encourages you to store versioned CSAF templates, because some properties always stay the same from advisory to advisory.

## Important Entries

Producing a valid CSAF document is a journey that takes you from yourself through your products to the vulnerabilities that plague them. This page is your map and traveling companion.

### Important Document Entries

Document properties provide information about the CSAF document itself. Among other things, they tell you how it can be identified, who created it when, and with whom you may share it.

#### Title

The [Title](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32111-document-property---title) of the document is meant to tell a human reader what this document is about. It makes sense to include the product name and the type of vulnerability in the title, but there are no formal restrictions.

> In Secvisogram, the title is found under "Document level meta-data".

#### Publisher

The [Publisher](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3218-document-property---publisher) section serves to uniquely identify you, the one publishing the document.

It contains the required fields "name", "namespace" and "category", and the optional fields "issuing authority" and "contact details". The values you provide here should be identical to the ones in your [provider metadata](/server/configuration/required/provider-metadata/#publisher-data-inputs) configuration, which is required to host CSAF documents. The documentation page contains more details on the values you should provide here.

#### Tracking

The [Tracking](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32112-document-property---tracking) section contains important meta-data about the document. It is primarily meant to be machine readable. The required fields are plenty:

- [ID:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321124-document-property---tracking---id) Together with your publisher namespace, the ID is used to identify a document. It thus needs to be unique within your organisation. Apart from that, the standard only requires that the ID does not start or end with a whitespace. However, it is recommended to only use lowercase letters, digits, and the symbols '+', '-' and '_'. This is because the standard recommends that [filenames](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#51-filename) for CSAF documents follow this pattern. Deviating from it could lead to confusion and even conflicts. There is no good reason for an ID not to be identical to its filename.
- [Initial Release Date](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321125-document-property---tracking---initial-release-date) and [Current Release Date](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321122-document-property---tracking---current-release-date) are blissfully self-explanatory fields.
- [Status:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321127-document-property---tracking---status) This must be one of "draft", "interim" or "final". The status serves to tell your users at which rate the document is expected to change. Before the initial release date, the status must be "draft".
- [Version:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321128-document-property---tracking---version) You can either use [semantic versioning](https://semver.org/), or a [natural number](https://www.cuemath.com/numbers/natural-numbers/) as your document version. Before the initial release date of your document, you may choose 0 as the (semantic) major version, or as the natural number version. After the initial release, the number must be at least 1. Whenever you change your document, you have to increment the version. For semantic versions this means increasing at least the patch version, while for natural number versions the number needs to increase at least by 1.
- [Revision History:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321126-document-property---tracking---revision-history) This needs to contain one entry for every version you published, with timestamp, version, and summary.

#### Distribution - TLP

Though you are not required to classify the CSAF document, you probably want to. This is done using the [Traffic Light Protocol (TLP)](https://www.first.org/tlp/), with which you can limit the information to a single individual, an organisation and its clients, a whole community, or not at all.

This classification has programatical consequences: A document classified as {{< tlp-white >}} or {{< tlp-clear >}} will be publicly shared by BOMnipotent, while documents with another classification require explicit authentication and access to be viewed.

If you do not specify a classification inside the document, BOMnipotent Server will use a configurable [default TLP](/server/configuration/optional/tlp-config/#default-tlp). This does however mean that the TLP information is lost once the document is downloaded from the server, which is why classification inside the document is recommended.

Please note that the [CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32152-document-property---distribution---tlp) only allows classification with the deprecated [TLP v1.0](https://www.first.org/tlp/v1/) labels. As long as you strictly follow it, the URL in the document should be https://www.first.org/tlp/v1/ (which is not the one that Secvisogram offers).

However, many CSAF issuers prefer to classify their documents with the TLP v2.0 label {{< tlp-amber-strict >}}, which only allows sharing within a single organisation. You can [configure BOMnipotent](/server/configuration/optional/tlp-config/#allowing-tlp-v20) to also accept CSAF documents classified using TLP v2.0 labels.

### Important Product Tree Entries

The product tree contains the information which products are covered by the advisory. They are grouped in branches, which, similar to namespaces, serve to structure your catalogue.

Consider creating a template containing all your products (or product families, if this better suits your needs). Deleting irrelevant products from an advisory is a matter of seconds, while adding missing ones carries the risk to forget some.

#### Branches

[Branches](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#312-branches-type) always have exactly 3 fields: A [name](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3123-branches-type---name), a [category](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3122-branches-type---category), and then either a [product](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#313-full-product-name-type) or more branches.

This recursive devinition is meant to begin on a high-level overview, and then go down to individual releases. A very plausible structure is the following:
- A top level branch with the category "vendor". The name is your organisation's name.
- The "vendor" branch contains a branch with category "product_name" for each of your products. If they become too numerous, you may consider addionally grouping them in branches with the category "product_family".
- Each "product_name" branch contains a branch for each "product_version". Here it is important that the name of the branch is actually a version, and not a version range. There is a separate category for that.
- If you build for different architectures, you may want to include a sub-branch with category "architecture".

Whatever branch structure you settle on in the end, the lowermost branches need to contain a product field. It needs to contain the following fields:
- [Name:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3131-full-product-name-type---name) A name, ideally unique, that helps human readers to identify the product. This may well just be the concatenation of all branch names leading to this point.
- [Product ID:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#318-product-id-type) The product ID is used to reference this particular product within the current document. It has no particular requirements, besides being unique in the document.

The product may contain a [product identification helper](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3133-full-product-name-type---product-identification-helper). This is primarily relevant to help others identify your product from outside the current document.

### Important Vulnerabilities Entries

[Vulnerabilities](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#323-vulnerabilities-property) are entries that tell your users which products are (not) affected by a vulnerability, and which actions need to be taken.

#### Title

The [title](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32315-vulnerabilities-property---title) is used so that human readers know which vulnerability is covered by this CSAF document.

#### CVE and IDs

These important fields are used by machines to identify a vulnerability. Several systems for identifying vulnerabilities exist. The most well known is the [Common Vulnerabilities and Exposures (CVE)](https://www.cve.org/) tracking number. If the vulnerability has a CVE, you can enter it in the [corresponding field](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3232-vulnerabilities-property---cve).

If the vulnerability is tracked using another system, you can specify its id in the [IDs](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3236-vulnerabilities-property---ids) field. Each of its entries contains two fields:
- System Name: Used to identify the tracking system. This could for example be "GitHub Security Advisories", but also "GitHub Issue". Only "CVE" is not allowed, because you specify CVEs via the dedicated field.
- Text: The actual value of the id, like "GHSA-abcd-efgh-ijkl" or "Weichwerke-Heidrich-Software/bomnipotent_doc#37".

> *Note*: In Secvisogram, you need to set the "Active Relevance Level" to 4 in order to be able to enter IDs that are not CVEs.

#### Notes

Each vulnerability needs to have at least one [note](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#315-notes-type) attached to it. A note has a category and a content. Most of the times, it is sufficient to add a note with category "description", and copy the description of the vulnerability from the official source.

The situation is of course different if the vulnerability does not have an official description, because it originated directly from your product. In this case you should add another note with the "details" category.

#### Product Status

The lists of [product stati](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3239-vulnerabilities-property---product-status) can be considered the heart of the advisory. They are machine-readable lists containing the information whether or not each product is affected by a vulnerability. It is recommended to sort all your product identifiers (meaning every version of every product) into at least the following categories:
- Known affected: These versions are affected by the vulnerability.
- Fixed: These versions contain a fix and are thus not affected by the ability.
- Recommended: This is the version you recommend to use. It should ideally also appear in your "fixed" list.

It is not unusual that a vulnerability in your supply chain does not actually affect your product. This may be because your product never uses the vulnerable paths. In this case you may also want to add entries to "known not affected". Otherwise, users of your product with access to your SBOM may get notified about the vulnerability and inquire whether or not they have to act.

> *Note*: In Secvisogram, you need to set the "Active Relevance Level" to 4 in order to be shown all available stati.

#### Remediations

For every product that is affected (or under investigation), you need to create at least one entry describing a [remediation](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32312-vulnerabilities-property---remediations). It must contain:
- a category, for example "mitigation", "workaround" or "no_fix_planned" (risk acceptance is a viable strategy).
- details on how the remediation is applied, or why no fix is planned.
- a reference to at least one product id.
