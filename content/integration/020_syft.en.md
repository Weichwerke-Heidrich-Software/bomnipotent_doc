+++
title = "SBOMs with Syft"
slug = "syft"
weight = 20
description = "Learn what and why Software Bills of Materials (SBOMs) are, and how to easily generate them using the open-source tool Syft."
+++

A Software Bill of Material (SBOM) is a list of all software components used in your product. In the contex of supply chain security, it serves as a machine-readable list of items to compare to whenever a new vulnerability surfaces.

Several tools exist to automatically generate such an SBOM. This tutorial focuses on Anchore's [Syft](#syft), an open source command line tool.

## BOMs

### What are BOMs?

The Bill of Material is a concept predating software. It is a list of all components that went into making a product. In the context of software supply chain security it is a structured, machine-readable document listing the components of a product.

In the early days, SBOMs were primarily used to ensure compliance with various licensing models: Copyleft open-source licenses for example require that all projects using the dependency must also themselves be distributed under a copyleft license. An SBOM can be used to check that no package with a copyleft license is used in a commercial product.

A few years later people began to recognise the huge potential of SBOMs for supply chain security: If a vulnerability in a widely used software package becomes known, one look into a thorough SBOM will suffice to tell if a product is potentially containing this vulnerability.

Today all the focus is on automation: A BOM can be compared to a public vulnerability database at next to no cost, so a [pipeline](/integration/ci-cd/) can check for new vulnerabilities each day. This automation is the key to dramatically shorten the timespan between a vulnerability becoming known in a dependency, and becoming fixed in the final product.

BOMs exist not only for software:
- [Hardware Bills of Materials](https://cyclonedx.org/capabilities/hbom/) (HBOMs) most closely resemble the classical BOM.
- [Cryptography Bills of Materials](https://cyclonedx.org/capabilities/cbom/) (CBOMs) contain information on which cryptographic techniques are used in a project.
- [Artificial Intelligence Bills of Materials](https://owaspaibom.org/) (AIBOMs) have recently gathered attention to document how an AI model has been trained.

This list is far from exhaustive.

### Unique Identifiers

The primary value of a BOM from a supply chain security perspective is that it can be compared to vulnerability databases. In order to make that possible, any component in a BOM needs a unique, machine-readable identifier as the lookup key in said databases. The most widely supported formats are CPE and PURL.

> This is not completely true: BOMnipotent can use a component's name and version to [match](/client/consumer/boms/#match) against CSAF security advisories, thus giving access to vulnerabilities beyond those listed in public databases.

#### CPE

The [Common Platform Enumeration](https://en.wikipedia.org/wiki/Common_Platform_Enumeration) (CPE) is a scheme primarily used to search for Common Vulnerabilities and Exposures (CVEs). Both formats are maintained by NIST. CPE has the following form:
```
cpe:<cpe_version>:<part>:<vendor>:<product>:<version>:<update>:<edition>:<language>:<sw_edition>:<target_sw>:<target_hw>:<other>
```
Most fields allow wildcard characters '*', matching all results of that part. For example, a valid CPE for version 1.3.0 of BOMnipotent is:
```
cpe:2.3:a:Weichwerke Heidrich Software:BOMnipotent:1.3.0:*:*:*:*:*:*:*
```
Arguably the most important parts of the CPE are 'product' and 'version', because these are used by most algorithms as lookup keys for vulnerabilities.

#### PURL

The [Package Uniform Resource Locator](https://github.com/package-url/purl-spec) (PURL, not to be confused with the "Persistent Uniform Resource Locator", also abbreviated PURL) serves a very similar purpose as the [CPE](#cpe), but with a more focused scope. This means that it is less powerful, but also shorter and simpler.

The general scheme is:
```
<scheme>:<type>/<namespace>/<name>@<version>?<qualifiers>#<subpath>
```
Of these, only 'scheme', 'type' and 'name' are required arguments. For example, a valid PURL for version 1.2.1 of [cwenum](https://github.com/Weichwerke-Heidrich-Software/cwenum) is:
```
pkg:cargo/cwenum@1.2.1
```

> As the name suggests, Package-URLs are only intended for packages. This is why BOMnipotent, an application, can not serve as an example here.

### Format and Structure

The two most widely used formats for BOMs are [SPDX](https://spdx.dev/) and [CycloneDX](https://cyclonedx.org/). Since the latter has a stronger focus on security aspects, and because both formats can be converted into the other, this article focuses on CycloneDX.

> As of version 1.3.0, BOMnipotent only supports BOMs in CycloneDX format. There are currently no plans to support SPDX.

CycloneDX is a scheme for either JSON or XML format. It mainly consists of up to four sections:
- The object 'metadata.component' specifies the product for which the BOM lists the components. According to the standard it is optional, but a proper BOM should at least list the name and version of the described product.
- The 'components' section is the heart of the BOM. It lists all components contained in the product. Each component should at the very least contain a name, a version, a [CPE](#cpe) and a [PURL](#purl).
- The 'dependencies' section turns the flat list of components into a dependency tree. It contains the information which component depends on which other component. While this greatly aids a human in getting a grasp on the product, it is entirely optional and does not affect the automatic vulnerability detection.
- A BOM may be enriched by a 'vulnerabilities' section. Each vulnerability references a component where the vulnerability occurred, and typically contains an ID, a severity rating and a description.

An important aspect to consider is that every section of the BOM except for the vulnerabilities is considered *static* information, while the vulnerabilities are considered *dynamic*: The component structure of a specific product release does not change, while vulnerabilities may always be discovered after the release.

> This is why BOMnipotent's command to create a BOM is called ["upload"](/client/manager/doc-management/boms/#uploading), while the analogous command for vulnerabilities is called ["update"](/client/manager/doc-management/vulnerabilities/#updating).

### Scope

A valid BOM does not necessarily include all components of a product. It may for example be shallow, only including the direct dependencies, but not their dependencies. For software written in an ecosystem with a package manager, it is typically very easy to generate a close to complete list of components -- for other software or even hardware it is typically not.

When deciding which components to include in a BOM, it is important to think about the scope of the application: What is shipped to the customer in the end? Is it an application? A container? A computer with an operating system? A complete machine?

Depending on the answers to these questions, a complete BOM may currently not easily be generated by a tool. Especially for hardware components it is often necessary to maintain a separate BOM by hand.

## Syft

Syft is a command line tool for generating an SBOM. Especially for software projects utilising a package manager it easily integrates into a workflow for automatically creating a BOM with every release.

### Setup and Usage

The official [Syft GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#installation) contains installation instructions. It is available via a shell script or via various package managers.

On some linux systems you may want to change the install path (the very last argument to the shell command) to "~/.local/bin", because "/usr/local/bin" requires root permissions to modify.

{{< example install_syft >}}

The basic usage of Syft is:
```
syft <target> [options]
```
Additionally, some configuration can be made using environment variables.

Syft supports lockfiles, directories, container images and more as targets.

Once your SBOM is generated, you can use BOMnipotent Client to [upload it to BOMnipotent Server](/client/manager/doc-management/boms/#uploading).

After that you can use Grype to periodically [scan for vulnerabilities](/integration/grype/).

### Lockfile

An example call looks like this:

{{< example syft_lockfile >}}

Breakdown:
- 'SYFT_FORMAT_PRETTY=1' makes this call with an environment variable that tells Syft to use prettified output. This only serves to make the resulting JSON easier to read for humans. See [here](https://github.com/anchore/syft/wiki/configuration) for a full list of configurations.
- 'syft' calls the Syft program.
- 'Cargo.lock' tells Syft to analyse the lockfile of the Rust ecosystem.
- 'output cyclonedx-json=./sbom.cdx.json' specifies that the output is to be stored in the [CycloneDx](https://cyclonedx.org/) JSON format  in the file './sbom.cdx.json'.
  - Note that '.cdx.json' is the [recommended file extension](https://cyclonedx.org/specification/overview/#recognized-file-patterns).
- 'source-name="BOMnipotent"' explains to Syft that these are the sources for the product BOMnipotent, which it may not automatically detect in all cases.
  - The CycloneDX schema may not require a component name, but BOMnipotent does.
- Likewise 'source-version="1.0.0"' tells Syft the current version of your product.
  - If you do not provide a version, BOMnipotent will try to use the timestamp as a version string instead.

Syft supports a wide range of ecosystems, which are listed on their [GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#supported-ecosystems).

### Directory

Letting Syft loose on a whole directory is possible, but overdoes it in most situations. It will go through all subdirectories and collect everything that looks remotely like a lockfile, including all your test dependencies, development scripts and GitHub Actions.

{{< example syft_dir >}}

### Container

If you have a docker container exported as a '.tar' file you can also specify that as a target:

{{< tabs >}}
{{% tab title="long" %}}
```
syft container.tar --output cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{% tab title="short" %}}
```
syft container.tar -o cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{< /tabs >}}

For compiled languages the results will be vastly different, because most information about the components that went into compilation is lost. On the other hand, this SBOM contains information about the environment that your product may later run in.
