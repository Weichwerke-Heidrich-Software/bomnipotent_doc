+++
title = "OpenPGP Keys"
slug = "open-pgp"
weight = 60
+++

## What is OpenPGP (not)?

Open Pretty Good Privacy (OpenPGP) is an open standard for several file formats in the context of cryptography. Its most prominent use is the end-to-end encryption of emails, but it can also be used to cryptographically sign any data, including other OpenPGP files.

> "Signing" means adding a "signature" to a message, a bit of text allowing anyone with a public key to verify that it has been approved by the person with the corresponding secret key.

The earliest version of the standard stems from [1998](https://www.rfc-editor.org/rfc/rfc2440), the latest (at the time of writing) [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) from 2024. Another important milestone that will become important in this article is [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) from 2007.

During its lifetime, OpenPGP has been adopted by many people and products, especially in the cybersecurity community, because it is pretty good. Also during and before this timespan, several closely related and not so aptly named concepts and products were developed, which can be pretty confusing.

To grasp an idea of what OpenPGP is, it is perhaps best to contrast it to what it is not.

### OpenPGP vs. RSA

[RSA](https://en.wikipedia.org/wiki/RSA_cryptosystem) is a *mathematical algorithm* for asymetric key encryption. It specifies what a public and secret key look like, and how they can be used to encrypt, decrypt, sign and verify data.

> There are several other such algorithms, but for a long time RSA was and probably still is the most widely used.

OpenPGP on the other hand is an *abstraction*. It is designed to be mostly algorithm-agnostic, meaning that for the most part you do not need to know which algorithm is used during an operation.

The [standard of 2024](https://www.rfc-editor.org/rfc/rfc9580) does not support post-quantum encryption algorithms, but the German [BSI](https://www.bsi.bund.de/) intends to change that with an [upcoming version](https://datatracker.ietf.org/doc/draft-ietf-openpgp-pqc/).

### OpenPGP vs. PGP

OpenPGP is a *standard*, meaning a set of formal rules that a program has to follow in order to be interoperable with other programs complying with the same standard.

PGP is *one such program* implementing the OpenPGP standard. In fact, it is the first program to implement the standard, because it predates OpenPGP by 7 years, being released in 1991. Due to legal concerns, the open standard was derived *from* PGP, and not the other way round.

As a commercial program, PGP changed ownership several times, and is currently developed by [Broadcom](https://www.broadcom.com/products/cybersecurity/information-protection/encryption).

### OpenPGP vs. GPG

[GNU Privacy Guard](https://gnupg.org/) (GPG) is *another program* implementing the OpenPGP *standard*. Contrary to the commercial PGP program, it is distributed under a free [GNU General Public License](https://en.wikipedia.org/wiki/GNU_General_Public_License). The devlopers [discussed](https://lists.gnupg.org/pipermail/gnupg-devel/1998-February/014190.html?utm_source=chatgpt.com) whether the name is too similar to PGP, and decided that it is not. Since GPG is free software, you are free to disagree.

More precisely, GPG is a program implementing *LibrePGP*, which implies that it is implementing OpenPGP [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880), but not the more current [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580).

### OpenPGP vs. LibrePGP

In 2023, when [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) of the OpenPGP standard was about to replace [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) from 2007, several people considered the proposed changes to be too disruptive. Most notably, the developers of [GPG](https://gnupg.org/) and [RNP](https://www.rnpgp.org/) (an extension for thunderbird) [decided](https://lwn.net/Articles/953797/) **not** to adopt the new standard, and to instead create the *new, competing standard* [LibrePGP](https://librepgp.org/) based on OpenPGP version 4.

Because GPG and its Windows variant [Gpg4win](https://gpg4win.de/index.html) are so widely used, it is (at the time of writing, July 2025) probably advisable to use the last common ancestor version 4 / RFC 4880 whenever given the choice, until both standards are widely supported.

### OpenPGP vs S/MIME

[Secure Multipurpose Internet Mail Extensions](https://en.wikipedia.org/wiki/S/MIME) (S/MIME), like OpenPGP, is a *standard* primarily aimed at offering end-to-end encryption for emails. The two standards have similar capabilities, but they are *not* interoperable.

The primary conceptual difference between S/MIME and OpenPGP is how they answer the question: "Can I trust this public key?"

S/MIME is based on [X.509 certificates](https://en.wikipedia.org/wiki/X.509), which have the notion of a "chain of trust". The beginning of this chain is formed by a *centralised* certificate authority, who are associated with a public key that is stored on your computer. This certificate authority signs other certificates (typically in exchange for money and the presentation of an ID), effectively telling your computer that it trusts them. Since your computer trusts the certificate authority, it then trusts these signed certificates.

OpenPGP on the other hand uses a "web of trust". *Everyone* can testify to the authenticity of others. If enough people that your computer trusts have signed a certain certificate, your computer may choose to trust that certificate as well.

> In the context of email encryption, S/MIME is a very valid alternative to OpenPGP, especially for businesses. BOMnipotent, however, requires OpenPGP keys.
