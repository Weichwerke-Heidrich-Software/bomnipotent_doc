+++
title = "Vulnerability Detection with Grype"
slug = "grype"
weight = 20
+++

Once your SBOM is generated, it is time to continuously scan it for vulnerabilities. Note that some laws, for example the EU's Cyber Resiliance Act, require that products are released without any known vulnerability. The first scan should therefore happen before a release.

There are several tools for scanning a product for supply chain vulnerabilities. This tutorial uses Anchore's Grype, because it integrates well with Anchore's Syft from the [SBOM tutorial](/integration/syft). Like Syft, Grype is an open source command line utility.

## Setup

The official [Grype GitHub repo](https://github.com/anchore/grype#installation) contains installation instructions. Like for Syft, you may want to change the install path (the very last argument to the shell command) to `~/.local/bin`, because `/usr/local/bin` requires root permissions to modify.

## Usage

With an SBOM at hand, scanning for vulnerabilities is very easy:
```bash
grype sbom:./sbom.cdx.json --fail-on low
```

When running this command, Grype checks [several vulnerability databases](https://github.com/anchore/grype?tab=readme-ov-file#grypes-database) for matches with the components provided in the sbom. The option specifies that it exits with a non-zero error code if any with severity low or higher is discovered.
