+++
title = "Vulnerability Detection with Grype"
slug = "grype"
weight = 30
description = "Learn how to use Anchore's Grype to scan SBOMs for vulnerabilities, including setup, usage, and exporting vulnerability reports in CycloneDX format."
+++

Once your SBOM is generated, it is time to continuously scan it for vulnerabilities. Note that some laws, for example the EU's Cyber Resiliance Act, require that products are released without any known vulnerability. The first scan should therefore happen before a release.

There are several tools for scanning a product for supply chain vulnerabilities. This tutorial uses Anchore's Grype, because it integrates well with Anchore's Syft from the [SBOM tutorial](/integration/syft). Like Syft, Grype is an open source command line utility.

## Setup

The official [Grype GitHub repo](https://github.com/anchore/grype#installation) contains installation instructions. Like for Syft, you may want to change the install path (the very last argument to the shell command) to '~/.local/bin', because '/usr/local/bin' requires root permissions to modify.

## Usage

With an SBOM at hand, scanning for vulnerabilities is very easy:

{{< tabs >}}
{{% tab title="long" %}}
```
grype sbom:./sbom.cdx.json --fail-on low
```
{{% /tab %}}
{{% tab title="short" %}}
```
grype sbom:./sbom.cdx.json -f low
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
 ✔ Scanned for vulnerabilities     [2 vulnerability matches]  
   ├── by severity: 0 critical, 0 high, 2 medium, 0 low, 0 negligible
   └── by status:   2 fixed, 0 not-fixed, 0 ignored 
NAME    INSTALLED  FIXED-IN  TYPE        VULNERABILITY        SEVERITY 
ring    0.17.8     0.17.12   rust-crate  GHSA-4p46-pwfr-66x6  Medium    
rustls  0.23.15    0.23.18   rust-crate  GHSA-qg5g-gv98-5ffh  Medium
[0000] ERROR discovered vulnerabilities at or above the severity threshold
```

When running this command, Grype checks [several vulnerability databases](https://github.com/anchore/grype?tab=readme-ov-file#grypes-database) for matches with the components provided in the sbom. The 'fail-on' option specifies that it exits with a non-zero error code if any with severity 'low' or higher is discovered.

The syntax to export a vulnerability report consumable by BOMnipotent is similar to Syft:


{{< tabs >}}
{{% tab title="long" %}}
```
grype sbom:./sbom.cdx.json --output cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{% tab title="short" %}}
```
grype sbom:./sbom.cdx.json -o cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{< /tabs >}}

Grype integrates well with BOMnipotent. You can use the "bom get" command of BOMnipotent Client to directly print the contents of a BOM to the console output, and then pipe it to grype:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client bom get <BOM-NAME> <BOM-VERSION> | grype --output cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client bom get <BOM-NAME> <BOM-VERSION> | grype -o cyclonedx-json=./vuln.cdx.json
```
{{% /tab %}}
{{< /tabs >}}
