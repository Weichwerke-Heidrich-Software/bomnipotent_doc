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

> Grype currently has a small [known bug](https://github.com/anchore/grype/issues/2418) that makes it forget the version of the main component when it adds the vulnerabilities. This is a bit problematic because BOMnipotent needs the version to uniquely identify a product. One possible workaround is to re-add the version to the document, for example via `jq '.metadata.component.version = "<VERSION>"' "vuln.cdx.json" > "vuln_with_version.cdx.json"`. Starting with BOMnipotent v0.3.1 you can instead directly provide the version during the vulnerability upload, as described below.

## Updating

The command to update the vulnerabilities associated with a BOM is
```bash
bomnipotent_client vulnerability update <VULNERABILITIES>
```
``` {wrap="false" title="output"}
[INFO] Updated vulnerabilities of BOM vulny_0.1.0
```

The "\<VULNERABILITIES\>" argument needs to be a path to a file in [CycloneDX JSON](https://cyclonedx.org/) format.

Ideally, this file contains the name and version of the associated BOM, in which case they will automatically be read. If one of the values is missing (due to a [known bug](https://github.com/anchore/grype/issues/2418) in grype, for example), you can provide it with an optional argument:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client vulnerability update <VULNERABILITIES> --name=<NAME> --version=<VERSION>
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client vulnerability update <VULNERABILITIES> -n <NAME> -v <VERSION>
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[INFO] Updated vulnerabilities of BOM BOMnipotent_1.0.0
```

Vulnerabilities are meant to updated periodically. Doing so will completely replace any previous vulnerabilities associated a BOM. The uploaded CycloneDX document thus needs to contain a full list of all known vulnerabilities.

You can only update vulnerabilities for a BOM that exists on the server:
``` {wrap="false" title="output"}
[ERROR] Received response:
404 Not Found
BOM Schlagsahne_1.0.1 not found in database
```

## Listing

The section about [listing vulnerabilities](/client/consumer/vulnerabilities/) in the documentation for consumers covers most aspects of listing vulnerabilities.

One aspect not mentioned there is the "--unassessed" option. Providing it lists only those vulnerabilities that have no CSAF document associated with it. The output can be interpreted as a TODO list.

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client vulnerability list --unassessed
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client vulnerability list -u
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
╭─────────────┬─────────┬─────────────────────┬───────────────────────────┬───────┬──────────┬─────────┬─────────────────╮
│ Product     │ Version │ Vulnerability       │ Description               │ Score │ Severity │ TLP     │ CSAF Assessment │
├─────────────┼─────────┼─────────────────────┼───────────────────────────┼───────┼──────────┼─────────┼─────────────────┤
│ BOMnipotent │ 1.0.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│             │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│             │         │                     │ t`                        │       │          │         │                 │
│ vulny       │ 0.1.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│             │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│             │         │                     │ t`                        │       │          │         │                 │
╰─────────────┴─────────┴─────────────────────┴───────────────────────────┴───────┴──────────┴─────────┴─────────────────╯
[ERROR] Found 2 unassessed vulnerabilities.
```

In this mode, BOMnipotent Client exits with a code indicating an error if and only if there are unassessed vulnerabilites. This makes it easy to integrate this call in your periodic CI/CD.

You can freely combine this option with specifying a product name or version:

{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client vulnerability list <NAME> <VERSION> --unassessed
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client vulnerability list <NAME> <VERSION>  -u
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
[INFO] No unassessed vulnerabilities found
```
