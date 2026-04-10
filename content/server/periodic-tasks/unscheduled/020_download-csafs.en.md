+++
title = "Download CSAFs"
slug = "download-csafs"
weight = 20
description = "Periodically query external CSAF providers, opening up a new path to enrich BOMs with vulnerabilities."
+++

This task downloads CSAF documents from an external CSAF provider, matches them agains the components of all stored BOMs, and creates new [vulnerability entries](/client/manager/doc-management/vulnerabilities/#updating-classified-vulnerabilities) based on those matches.

The name of this task is "download_csafs", and it accepts the following [configurations](/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "download_csafs"
url = "https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json"
client_cert_chain = "/path/to/tls/certificate/chain.pem" # Optional, for mTLS
client_cert_key = "/path/to/tls/secret.key.pem" # Optional, for mTLS
period = "1 day" # Optional
scheduled = true # Optional
trusted_root = "/path/to/tls/certificate.pem" # Optional, for testing

[[tasks]]
name = "download_csafs"
url = "<other_provider_metadata>"
```

The "url" parameter is mandatory and must point to a provider-metadata of a CSAF server. This is used as an entry point to collect all CSAF documents on the server.

Many CSAF providers protect access to CSAF documents with a TLP classification other than {{<tlp-white>}}/{{<tlp-clear>}} by using Mutual Transport Layer Security (mTLS). This involves issuing a TLS certificate to the client along with a secret key, which the client can use to authenticate itself during requests.

To grant the periodic task access to this authentication mechanism, the arguments "client_cert_chain" and "client_cert_key" exist. These allow to provide it with a certificate chain and its corresponding secret key.

> The "certificate chain" contains the client certificate and the certificate of the authority that signed it. The order is ascending, starting with the client certificate.

The implementation of mTLS makes it possible to employ non-public CSAF documents as a basis for vulnerabilities in your own products.

> A vulnerability arises from matching a CSAF document against a BOM. The resulting TLP classification is the stricter of the two: If one of the documents is classified as {{<tlp-green>}}, and one as {{<tlp-amber>}}, then the vulnerability is always classified as {{<tlp-amber>}}.

Note that tasks can be configured several times with different parameters. This allows to independently query all distinct vendors of your used components.

The "trusted_root" parameter is used to create an encrypted HTTPS connection to a server with an otherwise invalid TLS certificate. This parameter exists solely to allow testing the setup with faked certificates. Productively used CSAF providers need to have valid TLS certificates signed by an official root certificate authority.
