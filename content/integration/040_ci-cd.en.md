+++
title = "CI/CD"
slug = "ci-cd"
weight = 40
+++

BOMnipotent is built with automation in mind. By design, it never prompts for a user input and is fully scriptable.

This page describes how to use BOMnipotent Client inside your CI/CD pipeline to [upload SBOMs](#upload-sboms) with every release, and to [check for vulnerabilities](#check-for-vulnerabilities) on a daily basis.

## Prerequisites

This setup assumes that you have a BOMnipotent Server instance up and running. Consult the [setup instructions](/server/setup/) if that is not yet the case.

The pipeline further requires that the server contains an approved robot user account with the BOM_MANAGEMENT and VULN_MANAGEMENT permissions. The sections on [account creation](/client/basics/account-creation/) and [access management](/client/manager/access-management/) contain more information on how to creat one.

## Upload SBOMs

### GitHub Action

TODO

### Other Pipeline

TODO

## Check for Vulnerabilities

### GitHub Action

TODO

### Other Pipeline

TODO
