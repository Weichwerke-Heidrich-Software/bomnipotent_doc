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

TODO

## Upload BOMs

A Bill of Materials (BOM) is a list of the components of a product. It is a *static* document, and thus each BOM is closely associated with a specific release of the product. Whenever the components of the (released) product change, it should be tagged with a new version, and associated with a new BOM.

This is why the step of uploading a BOM to the server should be run as part of the release pipeline.

### GitHub Action

TODO

### Other Pipeline

TODO

## Check for Vulnerabilities

### GitHub Action

TODO

### Other Pipeline

TODO
