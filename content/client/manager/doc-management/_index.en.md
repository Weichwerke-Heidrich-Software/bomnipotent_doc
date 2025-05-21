+++
title = "Document Management"
weight = 20
description = "Document Management in BOMnipotent: Manage BOMs and CSAF documents, check for vulnerabilities, and update security advisories efficiently."
+++

BOMnipotent knows two types of supply chain security documents: Bills of Materials (BOMs) and Common Security Advisory Framework (CSAF) documents. In addition, it can host information on vulnerabilities associated with a BOM.

A typical document management workflow looks like this:
1. A new version of a product is released, together with its corresponding BOM. The BOM may for example be generated with [syft](/integration/syft/). This document is [uploaded](/client/manager/doc-management/boms/) to the server. In contrast to the other documents, BOMs should be treated as static data. Modifying or deleting BOMs is possible, but rare.
1. An automated tooling or script regularly downloads the BOMs, and checks them for vulnerabilities. This may for example be done with [grype](/integration/grype/). The findings are [updated](/client/manager/doc-management/vulnerabilities/) on the server.
1. Another tooling or script regularly [checks](/client/manager/doc-management/vulnerabilities/) the BOMnipotent Server for new vulnerabilities and sounds an alarm when it finds one. A human mind is needed!
1. The human thoroughly analyses the vulnerability and determines if and how your customers have to react. They create a CSAF document, using for example [secvisogram](https://github.com/secvisogram/secvisogram). The CSAF document is [uploaded](/client/manager/doc-management/csaf/) to BOMnipotent Server.
1. Your consumers will now find the new CSAF document when they [poll](/client/consumer/boms/) your instance of BOMnipotent Server.
