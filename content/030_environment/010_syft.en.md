+++
title = "SBOM Generation with Syft"
slug = "syft"
weight = 10
draft = true
+++

A Software Bill of Material (SBOM) is a list of all software components used in your product. In the contex of supply chain security, it serves as a machine-readable list of items to compare to whenever a new vulnerability surfaces.

Several tools exist to automatically generate such an SBOM. This tutorial focuses on Anchore's Syft. It is an open source command line tool.

## Setup

The official [Syft GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#installation) contains installation instructions. It is available via a shell script or via various package managers.

On some linux systems you may want to change the install path (the very last argument to the shell command) to `~/.local/bin`, because `/usr/local/bin` requires root permissions to modify.

## Usage

Go to your project repository and for example call:
```bash
syft Cargo.lock --output cyclonedx-json=./lockfile_sbom.cdx.json --source-name="BOMnipotent" --source-version="1.0.0"
```
Breakdown:
- `syft` cals the Syft program.
- `Cargo.lock` tells Syft to analyse the lockfile of the Rust ecosystem.
- `--output cyclonedx-json=./lockfile_sbom.cdx.json` specifies that the output is to be stored in the [CycloneDx](https://cyclonedx.org/) JSON format  in the file `./sbom.cdx.json`.
  - Note that `.cdx.json` is the [recommended file extension](https://cyclonedx.org/specification/overview/#recognized-file-patterns).
- `--source-name="BOMnipotent"` explains to Syft that these are the sources for the `BOMnipotent` component, which it may not automatically detect in all cases.
  - The CycloneDX schema may not require a component name, but BOMnipotent does.
- Likewise `--source-version="1.0.0"` tells Syft the current version of your project.
  - If you do not provide a version, BOMnipotent will try to use the timestamp as a version string instead.

Syft supports a wide range of ecosystems, which is [listed on their GitHub repo](https://github.com/anchore/syft?tab=readme-ov-file#supported-ecosystems).

If you have a docker container exported as a `.tar` file you can also specify that as a target:
```bash
syft container.tar --output cyclonedx-json=./container_sbom.cdx.json --source-name="" --source-version=1.2.3
```
For compiled languages the results will be vastly different, because most information about the components that went into compilation is lost. On the other hand, this SBOM contains information about the environment that your product may later run in.

It is important to think about the scope: To which extend are you responsible for the security of your product?
