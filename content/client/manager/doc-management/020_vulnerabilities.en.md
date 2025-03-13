+++
title = "Vulnerabilities"
slug = "vulnerabilities"
weight = 20
+++

An activity at the core of supply chain security is to compare the contents of a BOM, meaning all components of a product, to databases of known vulnerabilities.

> For vulnerability interactions beyond reading, you need the VULN_MANAGEMENT permission. The [User Management Section](/client/manager/user-management/) describes how it is granted.

## Detecting

BOMnipotent does not itself detect new vulnerabilities. A tool that can be used in combination with BOMnipotent is [grype](https://github.com/anchore/grype#installation), which takes a BOM as input and produces a list of vulnerabilities as output. The [grype tutorial](/integration/grype/) contains some additional information on its usage. Other tools are available.

Using the BOMnipotent Client, you can directly print the contents of a BOM and pipe it to grype.

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client bom get <BOM-NAME> <BOM-VERSION> | grype --output cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client bom get <BOM-NAME> <BOM-VERSION> | grype -o cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{< /tabs >}}

This will check the software components agains several databases and add the result to the CycloneDX. It then stores all that in a file called "vuln.cdx.json" (or whichever other name you provide).

> Grype currently has a small [known bug](https://github.com/anchore/grype/issues/2418) that makes it forget the version of the main component when it adds the vulnerabilities. This is a bit problematic because BOMnipotent needs the version to uniquely identify a product. One possible workaround is to add the version to the document, for example via `jq '.metadata.component.version = "<VERSION>"' "vuln.cdx.json" > "vuln_with_version.cdx.json"`.

TODO: Or you can provide the version in the update commend, once #310 is implemented

TODO: More Doc