+++
title = "SBOM Generation with Syft"
slug = "syft"
weight = 10
+++

A Software Bill of Material (SBOM) is a list of all software components used in your product. In the contex of supply chain security, it serves as a machine-readable list of items to compare to whenever a new vulnerability surfaces.

Several tools exist to automatically generate such an SBOM. This tutorial focuses on Anchore's Syft, an open source command line tool.

## Setup

The official [Syft GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#installation) contains installation instructions. It is available via a shell script or via various package managers.

On some linux systems you may want to change the install path (the very last argument to the shell command) to "~/.local/bin", because "/usr/local/bin" requires root permissions to modify.

## Usage

The basic usage of Syft is:
```bash
syft <target> [options]
```
Additionally, some configuration can be made using environment variables.

Syft supports lockfiles, directories, container images and more as targets.

### Lockfile

An example call looks like this:
{{< tabs >}}
{{% tab title="long" %}}
```bash
SYFT_FORMAT_PRETTY=1 syft Cargo.lock --output cyclonedx-json=./sbom.cdx.json --source-name="BOMnipotent" --source-version="1.0.0"
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
SYFT_FORMAT_PRETTY=1 syft Cargo.lock -o cyclonedx-json=./sbom.cdx.json --source-name="BOMnipotent" --source-version="1.0.0"
```
{{% /tab %}}
{{< /tabs >}}
Breakdown:
- 'SYFT_FORMAT_PRETTY=1' is makes this call with an environment variable that tells Syft to use prettified output. This only serves to make the resulting json easier readable for humans. See [here](https://github.com/anchore/syft/wiki/configuration) for a full list of configurations.
- 'syft' cals the Syft program.
- 'Cargo.lock' tells Syft to analyse the lockfile of the Rust ecosystem.
- '--output cyclonedx-json=./sbom.cdx.json' specifies that the output is to be stored in the [CycloneDx](https://cyclonedx.org/) JSON format  in the file './sbom.cdx.json'.
  - Note that '.cdx.json' is the [recommended file extension](https://cyclonedx.org/specification/overview/#recognized-file-patterns).
- '--source-name="BOMnipotent"' explains to Syft that these are the sources for the BOMnipotent component, which it may not automatically detect in all cases.
  - The CycloneDX schema may not require a component name, but BOMnipotent does.
- Likewise '--source-version="1.0.0"' tells Syft the current version of your project.
  - If you do not provide a version, BOMnipotent will try to use the timestamp as a version string instead.

Syft supports a wide range of ecosystems, which is listed on their [GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#supported-ecosystems).

### Directory

Letting Syft loose on a whole directory is possible, but overdoes it in most situations. It will go through all subdirectories and collect everything that looks remotely like a lockfile, including all your test dependencies, development scripts and GitHub Actions.

{{< tabs >}}
{{% tab title="long" %}}
```bash
syft . --output cyclonedx-json=./dev_env_sbom.cdx.json --source-name="BOMnipotent Development Environment" --source-version=1.2.3
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
syft . -o cyclonedx-json=./dev_env_sbom.cdx.json --source-name="BOMnipotent Development Environment" --source-version=1.2.3
```
{{% /tab %}}
{{< /tabs >}}

### Container

If you have a docker container exported as a '.tar' file you can also specify that as a target:

{{< tabs >}}
{{% tab title="long" %}}
```bash
syft container.tar --output cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
syft container.tar -o cyclonedx-json=./container_sbom.cdx.json --source-name="BOMnipotent Container" --source-version=1.2.3
```
{{% /tab %}}
{{< /tabs >}}


For compiled languages the results will be vastly different, because most information about the components that went into compilation is lost. On the other hand, this SBOM contains information about the environment that your product may later run in.

### Final remarks

When deciding on a target, it is important to think about the scope of your application: What do you ship to the customer? Up to which extend are you responsible for the supply chain of your product? If in doubt, there's no harm in uploading more than one variant of a BOM, as long as product name or version are different.

Once your SBOM is generated, you can use BOMnipotent Client to [upload it to BOMnipotent Server](/client/manager/doc-management/uploading-boms/).

After that you can use Grype to periodically [scan for vulnerabilities](/integration/grype).
