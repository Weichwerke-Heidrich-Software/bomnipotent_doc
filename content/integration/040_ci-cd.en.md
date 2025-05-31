+++
title = "CI/CD"
slug = "ci-cd"
weight = 40
+++

BOMnipotent is built with automation in mind. By design, it never prompts for a user input and is fully scriptable.

This page describes how to use BOMnipotent Client inside your CI/CD pipeline to [upload BOMs](#upload-boms) with every release, and to [check for vulnerabilities](#check-for-vulnerabilities) on a daily basis.

Weichwerke Heidrich Software has created several ready-to-use GitHub A to integrate BOMnipotent into your pipeline. Most of them are intentionally based on bash scripts, to make the transfer to other pipeline environments as easy and seamless as possible.

## Prerequisites

This setup assumes that you have a BOMnipotent Server instance up and running. Consult the [setup instructions](/server/setup/) if that is not yet the case.

The pipeline further requires that the server contains an approved robot user account with the BOM_MANAGEMENT and VULN_MANAGEMENT permissions. The sections on [account creation](/client/basics/account-creation/) and [access management](/client/manager/access-management/) contain more information on how to creat one.

## Setup BOMnipotent Client

The task of making executables available is where various pipeline environments show the most differences. Luckily, it is also the task that DevOps engineers figure out very early on. This task is therefore currently only described for GitHub Actions, where a ready-to-use step exists.

### GitHub Action

The action to setup BOMnipotent Client can be found on the [GitHub Marketplace](https://github.com/marketplace/actions/setup-bomnipotent-client).

A typical snippet from you workflow yaml file looks like this (except for the indentation, because yaml...):

```yaml {{ title="Typical setup snippet" }}
- name: Install BOMnipotent Client
  uses: Weichwerke-Heidrich-Software/setup-bomnipotent-action@v1
  with:
    domain: '<your-server-domain>'
    user: '<your-robot-user>'
    secret-key: ${{ secrets.CLIENT_SECRET_KEY }} 
```

> A more complete example can be found on [GitHub](https://github.com/marketplace/actions/setup-bomnipotent-client).

The three parameters are optional, but recommended:
- domain: Provide the full domain (including subdomain) to your BOMnipotent Server instance. It will be stored in a session, so that you do not have to provide in subsequent calls.
- user: Store the username of your robot user, which you have set up during the [prerequisites](#prerequisites) section.
- secret-key: Provide a reference to the secret key used to authenticate the robot user. You can make it available to your pipeline via \<your repo\> → Settings → Secrets and variables → Actions → New repository secret. In the example above, it is named "CLIENT_SECRET_KEY".

> **Caution:** Do not directly store your secret key inside the pipeline, or any other versioned file. This is what the GitHub secret mechanism is designed to handle.

After running this action, the command "bomnipotent_client.exe" (Windows) or "bomnipotent_client" (UNIX) is available for the rest of the job. Because different jobs run inside different containers, it may be necessary to call the setup action several times throughout the workflow.

## Upload BOMs

A Bill of Materials (BOM) is a list of the components of a product. It is a *static* document, and thus each BOM is closely associated with a specific release of the product. Whenever the components of the (released) product change, it should be tagged with a new version, and associated with a new BOM.

This is why the step of uploading a BOM to the server should be run as part of the release pipeline.

Following the separation-of-concerns principle, the action to upload BOMs has some prerequisites:
- The BOMnipotent Client command has to be available. There is a [separate action](#setup-bomnipotent-client) that does just that.
- The action requires a BOM in CycloneDX format as input, which has to be generated in an earlier step.

The task of generating a BOM is highly specific to the product. The ideal tool depends on the ecosystem and how it is used. [Syft](/integration/syft/) is one tool that can assist, and that offers a ready-to-use [GitHub action](https://github.com/anchore/sbom-action). It is by far not the only option: The [CycloneDX Tool Center](https://cyclonedx.org/tool-center/) offers many alternatives.

### GitHub Action

An often used pattern is to trigger the release pipeline upon pushing a tag that corresponds to a semantic version:

```yaml {{ title="Possible trigger" }}
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
```

After setting up BOMnipotent Client and generating the BOM, it can be uploaded with the following snippet:

```yaml {{ title="Typical upload snippet" }}
- name: Upload SBOM
  uses: Weichwerke-Heidrich-Software/upload-bom-action@v0
  with:
    bom: './bom.cdx.json'
    name: '${{ github.event.repository.name }}'
    version: '${{ github.ref_name }}'
    tlp: 'amber'
```

The action accepts several arguments:
- bom: This is the only mandatory argument, it needs to point to an existing file containing a BOM in CycloneDX format. In this example, the bom was stored under "./bom.cdx.json".
- name / version: The CycloneDX standard does not require a BOM to have a name or version, but BOMnipotent does. If the tool used to create the BOM does not offer to set the name and/or version, you can overwrite them via arguments. In the example above, the repository name is used as the product name, and the triggering tag as the version. You may instead also specify a path to a file: The line `version: './version.txt'` for example would tell the action to read the file "./version.txt" and use the contents as the version string.
- tlp: You can specify a TLP label to classify the uploaded BOM. If not provided, the server's [default TLP](/server/configuration/optional/tlp-config/#default-tlp) applies.

A full list of arguments can be found on the [GitHub marketplace](https://github.com/marketplace/actions/upload-bom-to-bomnipotent-server).

### Other Pipeline

The GitHub action is merely a wrapper for a bash script. To upload a BOM using your pipeline infrastructure you can download and use the [script](https://github.com/Weichwerke-Heidrich-Software/upload-bom-action/blob/main/upload_bom.sh) from the repo.

```
if [ ! -f ./upload_bom.sh ]; then
    curl https://raw.githubusercontent.com/Weichwerke-Heidrich-Software/upload-bom-action/refs/heads/main/upload_bom.sh > ./upload_bom.sh
    chmod +x ./upload_bom.sh
fi
./upload_bom.sh <bom.cdx.json> <optional args...>
```

The script takes the same arguments as the action does, except that the bom argument is positional, and that optional arguments need to be prefixed with a double hyphen:
```
./upload_bom.sh ./bom.cdx.json --name <product-name> --version <product-version> --tlp amber
```

## Check for Vulnerabilities

### GitHub Action

TODO

### Other Pipeline

TODO
