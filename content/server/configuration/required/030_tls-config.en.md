+++
title = "TLS Config"
slug = "tls-config"
weight = 30
description = "Learn how to configure TLS for BOMnipotent Server, including setting up certificates and keys, to ensure secure HTTPS communication."
+++

> The TLS configuration **does not** support hot reloading. You will need to restart the server after modifying it.

## What is TLS?

> This section serves to give people who never had to deal with TLS a broad understanding of the process. Feel free to skip ahead to the [section about configuration](#tls-configuration).

Transport Layer Security (TLS), sometimes also called by its legacy name Secure Socket Layer (SSL), is what puts the "S" in "HTTPS". It is a very sophisticated, smart and widely used method for end-to-end encrypting of communication over the internet, but it can also lead to a lot of head scratching.

In very broad terms, TLS works as outlined in the following paragraphs:

Your server generates a pair of secret and public key. Anyone can use the public key to either *en*crypt a message that only the secret key can *de*crypt, or to *de*crypt a message that was *en*crypted with the secret key.

When a client reaches out to your sever asking for encryption, the latter responds by sending a TLS certificate. It contains several important field:
- Your severs public key, which the client can now use to send messages only the server can read.
- The domain(s) this certificate is valid for. These are usually stored in the field "Subject Alternative Names" (SAN), and are meant to ensure that the client is really talking to the address it wanted to reach.
- A digital signature, cryptographically proving that the certificate was not altered along the way.
- Many more. Just have a look at any certificate in your browser.

The digital signature is *not* created with the server's secret key, because the client does not trust that key yet. Instead, there are some (several hundred) public keys stored on your machine that belong to so called "Root Certificate Authorities". The job of these is to sign server certificates after they have verified that the bearer of the secret key is also the owner of the domains they claim.

For practical reasons the root CAs usually do not directly sign a server certificate, but rather an intermediate certificate, which is then used to sign the final certificate.

All in all, the chain of trust thus looks like this:
1. The Client trusts the root CA.
1. The root CA trusts the intermediate CA.
1. The intermediate CA trusts the server.

Thus, the client decides to trust the server and establich an encrypted connection.

## TLS Configuration

Because BOMnipotent is secure-by-default, it requires you to make at least one statement about TLS encryption. The "tls" section of your [configuration file](/server/configuration/config-file/) accepts the following fields:

```toml
[tls]
allow_http = false # Optional, is false by default
certificate_chain_path = "your-chain.crt"
secret_key_path = "your-key.pem"
```

Providing the TLS certificate paths is *required* if HTTP is not allowed (because the server could not offer any connection otherwise), and it is *optional* if HTTP is explicityl allowed by setting [allow_http](#allow_http) to true. If you set either the [certificate_chain_path](#certificate_chain_path) or the [secret_key_path](#secret_key_path), you will also need to set the other. Furthermore, the server checks if there is a mismatch between the two.

### allow_http

If you set this optional field to true, your BOMnipotent Server will allow unencrypted connections vie port 8080. This makes sense if your server is running behind a reverse proxy, and is communicating to it only over the local network. In this setup, the server is not directly reachable from the internet, so the reverse proxy can handle encryption for it.

Please note that the [OASIS CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#713-requirement-3-tls) requires that the access to your CSAF documents is encrypted!

### secret_key_path

The value of "secret_key_path" needs to point to a file that is reachable for BOMnipotent server. One common value is:
```toml
secret_key_path = "/etc/ssl/private/<yourdomain>_private_key.key"
```

> If your BOMnipotent Server is running inside a docker container, you may want to bind mount the container directory "/etc/ssl" to the directory with the same name on the host.

The file needs to be an [ASCII-armoured](https://openpgp.dev/book/armor.html) secret key in [PEM-Format](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail). Luckily, this is the format you typically receive when obtaining a TLS certificate.

The contents of the file could for example look like this:
``` {wrap="false" title="secret key"}
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEIHru40FLuqgasPSWDuZhc5b2EhCGGcVC+j3DuAqiw0/m
-----END PRIVATE KEY-----
```

> This is the secret key from a certificate generated for the BOMnipotent integration tests.

### certificate_chain_path

Likewise, the "certificate_chain_path" needs to point to a file reachable by BOMnipotent Server. A typical location is:
```toml
certificate_chain_path = "/etc/ssl/certs/<yourdomain>-fullchain.crt"
```

The chain needs to contain all certificates in the chain of trust concatenated together, **beginning** with the one for **your sever** and **ending** with the **root certificate authority**.

The contents of the full certificate chain for the integration test looks like this:
``` {wrap="false" title="certificate chain"}
-----BEGIN CERTIFICATE-----
MIIB8jCCAaSgAwIBAgIBAjAFBgMrZXAwPTELMAkGA1UEBhMCREUxHDAaBgNVBAoT
E0JPTW5pcG90ZW50IFRlc3QgQ0ExEDAOBgNVBAMTB1Rlc3QgQ0EwHhcNMjUwMzA1
MTMxNzEwWhcNMjUwNDI0MTMxNzEwWjBFMQswCQYDVQQGEwJERTEgMB4GA1UEChMX
Qk9Nbmlwb3RlbnQgVGVzdCBTZXJ2ZXIxFDASBgNVBAMTC1Rlc3QgU2VydmVyMCow
BQYDK2VwAyEAMzw8ZVgiuP3bSwh+xcBXu62ORwakr/D+s0XQks1BTFOjgcAwgb0w
DAYDVR0TAQH/BAIwADBIBgNVHREEQTA/gglsb2NhbGhvc3SCCTEyNy4wLjAuMYIT
c3Vic2NyaXB0aW9uX3NlcnZlcoISYm9tbmlwb3RlbnRfc2VydmVyMBMGA1UdJQQM
MAoGCCsGAQUFBwMBMA4GA1UdDwEB/wQEAwIGwDAdBgNVHQ4EFgQUC/RAGubXMfx1
omYTXChtqneWDLcwHwYDVR0jBBgwFoAUStstIFLzDjBSHYSsSr9hSgRVZT4wBQYD
K2VwA0EAXN/6PpJQ0guaJq67kdKvPhgjWVdfxxeCAap8i24R39s7XxNz5x5lPyxA
DQG63NS/OED43+GfpkUguoKxfZLBBA==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIBazCCAR2gAwIBAgIBATAFBgMrZXAwPTELMAkGA1UEBhMCREUxHDAaBgNVBAoT
E0JPTW5pcG90ZW50IFRlc3QgQ0ExEDAOBgNVBAMTB1Rlc3QgQ0EwHhcNMjUwMzA1
MTMxNzEwWhcNMjUwNjEzMTMxNzEwWjA9MQswCQYDVQQGEwJERTEcMBoGA1UEChMT
Qk9Nbmlwb3RlbnQgVGVzdCBDQTEQMA4GA1UEAxMHVGVzdCBDQTAqMAUGAytlcAMh
AIoFFlU/ADa77huqAb5aBY9stDwzzDd/Tdocb9RZDBG2o0IwQDAPBgNVHRMBAf8E
BTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUStstIFLzDjBSHYSsSr9h
SgRVZT4wBQYDK2VwA0EARYL+v9oDGjaSW5MhjjpQUFXnAVMFayaKFfsfbbkmTkv4
+4SRWFb4F/UULlbbvlskSgt8jAaaTSk7tu/iX67YDw==
-----END CERTIFICATE-----
```

The first certificate ("MIIB8j...") authenticates the server, the second one ("MIIBaz...") is that of the root CA.

> There is no intermediate certificate authority here because it is not required for the tests. In your productive environemnt with real certificates you will most likely need to add an intermediate certificate in the middle.
