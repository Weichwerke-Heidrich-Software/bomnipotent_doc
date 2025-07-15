+++
title = "Workflow Integration"
weight = 40
description = "Workflow Integration: Generate SBOMs, scan for vulnerabilities, and create CSAF documents using Syft, Grype, and secvisogram for BOMnipotent Server."
+++

Once the BOMnipotent Server is up and running, you can begin uploading documents. A typical workflow begins with generating an SBOM, an inventory of what components your product contains. This step should be automatically triggered upon creating a new release. Then this inventory is scanned for known vulnerabilities. This should also be an automatic step, but it should be triggered periodically. If a vulnerability is discovered, it is time to analyse it. This task needs expertise, and thus cannot be done automatically. The result of this analysis is a CSAF document, which tells your users if and how they have to react to this new development.

This section contains instructions for an exemplary workflow for [generating an SBOM using Syft](/integration/syft/), [scanning it for vulnerabilities with Grype](/integration/grype/), and [creating CSAF documents with secvisogram](/integration/secvisogram/). Other programs exists for these tasks, and as long as they produce valid CycloneDX and CSAF json documents, they are compatible with BOMnipotent.
