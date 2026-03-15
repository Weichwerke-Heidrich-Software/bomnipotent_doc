+++
title = "Download CSAFs"
slug = "download_csafs"
weight = 20
description = "Periodically query external CSAF providers, opening up a new path to enrich BOMs with vulnerabilities."
+++

This task downloads CSAF documents from an external CSAF provider, matches them agains the components of all stored BOMs, and creates new [vulnerability entries](/client/manager/doc-management/vulnerabilities/#updating-classified-vulnerabilities) based on those matches.

The name of this task is "download_csafs", and it accepts the following [configurations](/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "download_csafs"
url = "https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json"
period = "1 day" # Optional
scheduled = true # Optional
trusted_root = "/path/to/tls/certificate" # Optional, for testing

[[tasks]]
name = "download_csafs"
url = "<other_provider_metadata>"
```

The "url" parameter is mandatory and must point to a provider-metadata of a CSAF server. This is used as an entry point to collect all CSAF documents on the server.

Note that tasks can be configured several times with different parameters. This allows to independently query all distinct vendors of your used components.

The "trusted_root" parameter is used to create an encrypted HTTPS connection to a server with an otherwise invalid TLS certificate. This parameter exists solely to allow testing the setup with faked certificates. Productively used CSAF providers need to have valid TLS certificates signed by an official root certificate authority.
