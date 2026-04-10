+++
title = "Vulnerabilities"
slug = "vulnerabilities"
weight = 20
description = "Learn how to manage and update vulnerabilities in your BOM using BOMnipotent. Includes commands and troubleshooting tips."
+++

An activity at the core of supply chain security is to compare the contents of a BOM, meaning all components of a product, to databases of known vulnerabilities.

> For vulnerability interactions beyond reading, you need the {{<vuln-management-en>}} permission. The section about [Access Management](/client/manager/access-management/) describes how it is granted.

## Detecting

Vendors distribute vulnerabilities in their products over a wide variety of channels:
- The [Open Source Vulnerability (OSV) format](https://ossf.github.io/osv-schema/) is developed as a standard by Google. It is implemented by several databases, most notably the [OSV database](https://osv.dev/).
- The [National Vulnerability Database (NVD)](https://nvd.nist.gov/) offers a REST API.
- The [European Union Vulnerabilty Database (EUVD)](https://euvd.enisa.europa.eu/) offers a different REST API.
- Public GitHub repositories have a [security advisories section](https://docs.github.com/en/code-security/concepts/vulnerability-reporting-and-management/about-repository-security-advisories).
- Any meaningful CSAF document refers to at least one vulnerability.

There is an important distinction between the last and the other cases: CSAF documents may be classified via a TLP label, while all other vulnerabilities are publicly available information. This is why many databases are great tools when it comes to Open Source dependencies, where vulnerabilities tend to be made publicly available, but they have shortcomings when queried for closed source products.

BOMnipotent supports both kinds of sources via different mechanisms.

## Updating Public Vulnerabilities

Several good tools exist to collect vulnerabilities from public databases. BOMnipotent currently does not reimplement their functionality, but instead accepts their output.

One tool that can be used in combination with BOMnipotent is [grype](https://github.com/anchore/grype/), which takes a BOM as input and produces a list of public vulnerabilities as output. The [grype tutorial](/integration/grype/) contains some additional information on its usage. Other tools can be used as long as they provide output in [CycloneDX JSON format](https://cyclonedx.org/).

Using the BOMnipotent Client, you can directly print the contents of a BOM and pipe it to grype.

{{< example bom_get_grype_output >}}

This will check the software components against several databases and add the result to the CycloneDX. It then stores all that in a file called "vuln.cdx.json" (or whichever other name you provide).

> Grype currently has a small [known bug](https://github.com/anchore/grype/issues/2418) that makes it forget the version of the main component when it adds the vulnerabilities. This is a bit problematic because BOMnipotent needs the version to uniquely identify a product. One possible workaround is to re-add the version to the document, for example via `jq '.metadata.component.version = "<VERSION>"' "vuln.cdx.json" > "vuln_with_version.cdx.json"`. Starting with BOMnipotent v0.3.1 you can instead directly provide the version during the vulnerability upload, as described below.

The command to update the vulnerabilities associated with a BOM is:

{{< example vuln_update >}}

The "\<VULNERABILITIES\>" argument needs to be a path to a file in [CycloneDX JSON](https://cyclonedx.org/) format.

Ideally, this file contains the name and version of the associated BOM, in which case they will automatically be read. If one of the values is missing (due to a [known bug](https://github.com/anchore/grype/issues/2418) in grype, for example), you can provide it with an optional argument:

{{< example vuln_update_name_version >}}

Vulnerabilities are meant to updated periodically. Doing so will completely replace any previous vulnerabilities associated a BOM. The uploaded CycloneDX document thus needs to contain a full list of all known vulnerabilities.

You can only update vulnerabilities for a BOM that exists on the server:

{{< example vuln_update_nonexistent >}}

## Updating Classified Vulnerabilities

Some vendors, especially in the industry sector, do not typically make their vulnerabilities publicly available right away. This makes sense: As soon as a vulnerability is publicly known, it can be exploited. Instead, the vendors typically inform their customers of actions they have to take, and publicise the incident only after a grace period.

The CSAF standard was developed to automate this process. Vendors upload CSAF documents on their CSAF server, which can then be periodically queried by the customers.

Beginning with version 1.5.0, BOMnipotent supports the ["download_csafs"](/server/periodic-tasks/unscheduled/download-csafs/) periodic task. It downloads CSAF documents from an external CSAF provider, matches them agains the components of all stored BOMs, and creates new vulnerability entries based on those matches.

CSAF documents contain an affection status for their products, which determines whether or not a vulnerability has to be created for the component. The stati "first_affected", "last_affected", "known_affected" and "under_investigation" create a vulnerability entry, while the stati "fixed", "first_fixed", "known_not_affected" and "recommended" do not.

The resulting vulnerability is itself classified. Because it is a combination of a BOM and a CSAF document, which may in general have different classifications, the stricter of the two TLP labels is used. If both documents do not provide a classification, the [default TLP Label](/server/configuration/optional/tlp-config/) is used.

The task can be configured several times, allowing to independently query all distinct vendors of your used components.

## Listing

The section about [listing vulnerabilities](/client/consumer/vulnerabilities/) in the documentation for consumers covers most aspects of listing vulnerabilities.

One aspect not mentioned there is the "unassessed" option. With it, BOMnipotent Client lists only those vulnerabilities that do not have a CSAF document with status "final" associated with it.

> For this association to work, the CSAF document **must** contain [product_name and product_version](/integration/secvisogram/#association-with-boms) entries for the BOM in its branches.

{{< example vuln_list_unassessed >}}

In this mode, BOMnipotent Client exits with a code indicating an error if and only if there are unassessed vulnerabilites. This makes it easy to integrate this call in your periodic CI/CD.

You can freely combine this option with specifying a product name or version:

{{< example vuln_list_unassessed_name >}}
