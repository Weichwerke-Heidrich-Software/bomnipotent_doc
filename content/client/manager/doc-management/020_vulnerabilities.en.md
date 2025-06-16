+++
title = "Vulnerabilities"
slug = "vulnerabilities"
weight = 20
description = "Learn how to manage and update vulnerabilities in your BOM using BOMnipotent. Includes commands and troubleshooting tips."
+++

An activity at the core of supply chain security is to compare the contents of a BOM, meaning all components of a product, to databases of known vulnerabilities.

> For vulnerability interactions beyond reading, you need the {{<vuln-management-en>}} permission. The section about [Access Management](/client/manager/access-management/) describes how it is granted.

## Detecting

BOMnipotent does not itself detect new vulnerabilities. One tool that can be used in combination with BOMnipotent is [grype](https://github.com/anchore/grype), which takes a BOM as input and produces a list of vulnerabilities as output. The [grype tutorial](/integration/grype/) contains some additional information on its usage. Other tools can be used as long as they provide output in [CycloneDX JSON format](https://cyclonedx.org/).

Using the BOMnipotent Client, you can directly print the contents of a BOM and pipe it to grype.

{{< example bom_get_grype_output >}}

This will check the software components agains several databases and add the result to the CycloneDX. It then stores all that in a file called "vuln.cdx.json" (or whichever other name you provide).

> Grype currently has a small [known bug](https://github.com/anchore/grype/issues/2418) that makes it forget the version of the main component when it adds the vulnerabilities. This is a bit problematic because BOMnipotent needs the version to uniquely identify a product. One possible workaround is to re-add the version to the document, for example via `jq '.metadata.component.version = "<VERSION>"' "vuln.cdx.json" > "vuln_with_version.cdx.json"`. Starting with BOMnipotent v0.3.1 you can instead directly provide the version during the vulnerability upload, as described below.

## Updating

The command to update the vulnerabilities associated with a BOM is:

{{< example vuln_update >}}

The "\<VULNERABILITIES\>" argument needs to be a path to a file in [CycloneDX JSON](https://cyclonedx.org/) format.

Ideally, this file contains the name and version of the associated BOM, in which case they will automatically be read. If one of the values is missing (due to a [known bug](https://github.com/anchore/grype/issues/2418) in grype, for example), you can provide it with an optional argument:

{{< example vuln_update_name_version >}}

Vulnerabilities are meant to updated periodically. Doing so will completely replace any previous vulnerabilities associated a BOM. The uploaded CycloneDX document thus needs to contain a full list of all known vulnerabilities.

You can only update vulnerabilities for a BOM that exists on the server:

{{< example vuln_update_nonexistent >}}

## Listing

The section about [listing vulnerabilities](/client/consumer/vulnerabilities/) in the documentation for consumers covers most aspects of listing vulnerabilities.

One aspect not mentioned there is the "--unassessed" option. With it, BOMnipotent Client lists only those vulnerabilities that have no CSAF document associated with it.

{{< example vuln_list_unassessed >}}

In this mode, BOMnipotent Client exits with a code indicating an error if and only if there are unassessed vulnerabilites. This makes it easy to integrate this call in your periodic CI/CD.

You can freely combine this option with specifying a product name or version:

{{< example vuln_list_unassessed_name >}}
