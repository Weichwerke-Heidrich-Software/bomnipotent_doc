+++
title = "OpenPGP Keys with Sequoia"
slug = "open-pgp"
weight = 60
description = "Learn how to generate, export, and manage OpenPGP keys using Sequoia-PGP, with practical examples and key cryptography concepts explained."
+++

This article covers what the OpenPGP standard is and is not, and then goes into some examples on how to use it.

If you are only here for the practical part, feel free to [skip ahead](#using-openpgp).

> If you are looking to include your OpenPGP key pair in your instance of BOMnipotent Server, read the [section](/server/configuration/optional/open-pgp/) about the corresponding configuration.

## What is OpenPGP (not)?

Open Pretty Good Privacy (OpenPGP) is an open standard for several file formats in the context of cryptography. Its most prominent use is the end-to-end encryption of emails, but it can also be used to cryptographically sign any data, including other OpenPGP files.

> If the concept of signing is unfamiliar to you, there's a high-level description [down below](#signatures).

The earliest version of the standard stems from [1998](https://www.rfc-editor.org/rfc/rfc2440), the latest (at the time of writing) [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) from 2024. Another milestone that will become important in this article is [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) from 2007.

During its lifetime, OpenPGP has been adopted by many people and products, especially in the cybersecurity community, because it is pretty good. Also during and before this timespan, several closely related and not so aptly named concepts and products were developed, which can be pretty confusing.

To grasp an idea of what OpenPGP is, it is perhaps best to contrast it to what it is not.

### OpenPGP vs. RSA

[RSA](https://en.wikipedia.org/wiki/RSA_cryptosystem) is a *mathematical algorithm* for asymetric key encryption. It specifies what a public and secret key look like, and how they can be used to encrypt, decrypt, sign and verify data.

> There are several other such algorithms, but for a long time RSA was and probably still is the most widely used.

OpenPGP on the other hand is an *abstraction*. It is designed to be mostly algorithm-agnostic, meaning that for the most part you do not need to know which algorithm is used during an operation.

The [standard of 2024](https://www.rfc-editor.org/rfc/rfc9580) does not support post-quantum encryption algorithms, but the German [BSI](https://www.bsi.bund.de/EN/Home/home_node.html) intends to change that with an [upcoming version](https://datatracker.ietf.org/doc/draft-ietf-openpgp-pqc/).

### OpenPGP vs. PGP

OpenPGP is a *standard*, meaning a set of formal rules that a program has to follow in order to be interoperable with other programs complying with the same standard.

PGP is *one such program* implementing the OpenPGP standard. In fact, it is the first program to implement the standard, because it predates OpenPGP by seven years, being released in 1991. The open standard was derived *from* PGP, and not the other way round.

As a commercial program, PGP changed ownership several times, and is currently developed by [Broadcom](https://www.broadcom.com/products/cybersecurity/information-protection/encryption).

### OpenPGP vs. GPG

[GNU Privacy Guard](https://gnupg.org/) (GPG) is *another program* implementing the OpenPGP *standard*. Contrary to the commercial PGP program, it is distributed under a free [GNU General Public License](https://en.wikipedia.org/wiki/GNU_General_Public_License). The devlopers [discussed](https://lists.gnupg.org/pipermail/gnupg-devel/1998-February/014190.html?utm_source=chatgpt.com) whether the name is too similar to PGP, and decided that it is not. Since GPG is free software, you are free to disagree.

More precisely, GPG is a program implementing *LibrePGP* as well as OpenPGP [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880), but *not* the more current [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580).

### OpenPGP vs. LibrePGP

In 2023, when [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) of the OpenPGP standard was about to replace [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) from 2007, several people considered the proposed changes to be too disruptive. Most notably, the developers of [GPG](https://gnupg.org/) and [RNP](https://www.rnpgp.org/) (an extension for thunderbird) [decided](https://lwn.net/Articles/953797/) *not* to adopt the more current standard, and to instead create the *new, competing standard* [LibrePGP](https://librepgp.org/) based on OpenPGP version 4.

Version 4 / RFC 4880 has been obsoleted by version 6 / RFC 9580 for a reason, and the German BSI (which financially supports GPG) recommends using version 6 in Part 3 of its [technical guidelines](https://www.bsi.bund.de/EN/Themen/Unternehmen-und-Organisationen/Standards-und-Zertifizierung/Technische-Richtlinien/TR-nach-Thema-sortiert/tr03183/TR-03183_node.html) for the Cyber Resiliience Act. This guide therefore also recommends using version 6, even though the widely used GPG and its Windows variant [Gpg4win](https://gpg4win.de/) do not support it at the time of writing (September 2025).

### OpenPGP vs. S/MIME

[Secure Multipurpose Internet Mail Extensions](https://en.wikipedia.org/wiki/S/MIME) (S/MIME), like OpenPGP, is a *standard* primarily aimed at offering end-to-end encryption for emails. The two standards have similar capabilities, but they are *not* interoperable.

The primary conceptual difference between S/MIME and OpenPGP is how they answer the question: "Can I trust this public key?"

S/MIME is based on [X.509 certificates](https://en.wikipedia.org/wiki/X.509), which have the notion of a "chain of trust". The beginning of this chain is formed by a *centralised* certificate authority, who are associated with a public key that is stored on your computer. This certificate authority signs other certificates (typically in exchange for money and the presentation of an ID), effectively telling your computer that it trusts them. Since your computer trusts the certificate authority, it then trusts these signed certificates.

OpenPGP on the other hand uses a "web of trust". *Everyone* can testify to the authenticity of others. If enough people that your computer trusts have signed a certain certificate, your computer may choose to trust that certificate as well.

> In the context of email encryption, S/MIME is a very valid alternative to OpenPGP, especially for businesses. BOMnipotent, however, requires OpenPGP keys.

## Using OpenPGP

To manage OpenPGP keys, this guide recommends using the [Sequoia-PGP](https://sequoia-pgp.org/) command line tool. It is a commercially-backed open-source implementation of the OpenPGP standard. This means that there is financial motivation to maintain the project, while the code can be inspected by security researchers. The program is furthermore very [well documented](https://book.sequoia-pgp.org/).

> [!NOTE] Why not GPG?
> The developers of the more popular programs [GnuPG](https://gnupg.org) and its Windows variant [Gpg4Win](https://www.gpg4win.org) have decided against implementing the [latest and recommended](https://www.rfc-editor.org/rfc/rfc9580) OpenPGP standard. They instead created their own standard [LibrePGP](https://librepgp.org/), which is based on OpenPGP [version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880).

> [!INFO]
> To en- and decrypt emails you will need to use a plugin suitable for your email program. While this may be the primary use of OpenPGP keys, it is not the focus of this guide.

### Installation

#### From Repository

The Sequoia-PGP documentation offers several options [how to install](https://book.sequoia-pgp.org/installation.html) the program on various platforms. It does not directly support Windows, though. Instead, it recommends using the Windows Subsystem for Linux (WSL), which is thankfully easy to [set up](https://learn.microsoft.com/en-gb/windows/wsl/install).

This guide is based on Sequoia-PGP version 1.3.1, which is shipped with Debian 13 "Trixie". If you are uncertain which version your repository contains, try running:

{{< example apt_cache_policy_sq >}}

If the version is above 1.0.0 you can in good concience install from this source:

{{< example install_sq_apt >}}

#### From Sources (Debian 12 and earlier)

Regular Debian users will not be surprised to hear that the program version in the repository can be several years behind. Debian 12 ships with SequoiaPGP v0.27.0. If your repository version is this far behind, it is recommended to instead follow the steps to [build the program](https://book.sequoia-pgp.org/installation.html#install-from-source) from the sources (or to update to a newer operating system). This requires the Rust toolchain. Luckily, installing it is also [pleasantly straightforward](https://www.rust-lang.org/tools/install).

> Windows users, remember to run the **Linux** installation **inside** the WSL.

Afterwards, you need to install some system libraries as [outlined](https://book.sequoia-pgp.org/installation.html#install-the-dependencies-debian-12-bookworm--ubuntu-2404) in the instructions, because Sequoia-PGP is not written in pure Rust (which is the reason it is incompatible with Windows):

{{< example install_sq_deps >}}

Finally, call:

{{< example install_sq >}}

This will build Sequoia-PGP and make the "sq" command available in your terminal.

### Key Generation

> [!INFO] Key Terminology
> When it comes to asymetric cryptography, BOMnipotent and this documentation use the term "public key" for the key that you can freely share with the world, and the term "secret key" for the key only you should have access to. Sequoia-PGP and its documentation on the other hand use the term "cert" or "certificate" for public keys, and simply the term "key" for secret keys.

Once Sequoia-PGP is installed, you can generate a new key with the command:

{{< example sq_generate >}}

The command will prompt you for a password. If you leave it empty, the file is unencrypted.

This will directly add it to your keystore, meaning that Sequoia-PGP knows of it. The keystore specific to Sequoia-PGP, and it is a slightly different concept than the (operating system wide) keyring.

The "shared-key" parameter tells the program that you do not have the highest level of trust in this key. The other viable parameter is "own-key", meaning you fully trust it. One of the two needs to appear in the command.

The parameters "name" and "email" are used to identify the owner of the key. This not only tells others who this key belongs to, but is also helps you when interacting with your keys.

The option "profile" with the value "rfc9580" tell Sequoia-PGP to use the recommended [version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) of the OpenPGP standard.

More options can be found in the [documentation](https://book.sequoia-pgp.org/sq_key_generation.html), or by calling:

{{< example sq_generate_help >}}

You can list all your keys with the command:

{{< example sq_key_list >}}

### Exporting Keys

#### Public Keys

To export a public key (a "certificate") from your keystore, call:

{{< example sq_cert_export >}}

This command leverages the fact that you specified an email address when [generating](#key-generation) the key. Otherwise you would need to lookup and use the footprint to identify the public key you want to export.

Without the "output" option, the key is simply printed to the standard terminal output.

You can now for example host this file at the root level of your server, and point to it in the encryption section of your [security.txt](https://securitytxt.org/).

#### Secret Keys

In order to allow BOMnipotent to sign documents for you, you will also need to export your secret key:

{{< example sq_key_export >}}

This file can of course **not** be freely shared, but should rather be treated like a password.

### Signatures

#### Basic Principle

A signature is an object (think of it as a string, some bytes, or a large number) that verifies that some data (an email, a text file, a program) has been approved by someone (the signer) in the current state. If you trust the signer and verify the signature, you can then be sure that the data has not been tempered with. On a high level, the whole process works like this:
1. The signer calculates a cryptographic hash of the data. A hash can be thought of as a lengthy string that is vastly different for only slightly different data input.
1. The signer sort of encrypts that hash using their secret key, in a way that it can be decrypted with their public key. The result is the signature. Note that this key usage is the opposite of what asymetric encryption typically looks like.
1. The verifier decrypts the signature, using the public key of the signer. The result is the hash. Now the verifier knows that the hash comes from the signer, because only they have the secret key to encrypt a string in such a way that the public key decrypts it.
1. The verifier also independently calculates the hash from the data. If the value agrees with that from the signer, then the verifier knows that the data has not been modified.

Signatures can either be *inlined*, meaning they are directly appended to the data they sign, or they can come in a separate *signature file*, if the original data does not allow appending a signature. Sequoia-PGP can handle both cases.

#### Cleartext vs. Message

For inline signatures, OpenPGP (and by extension Sequoia-PGP) recognises the "cleartext" and "message" variants.

Inline-signed "cleartext" data is contained in the output in its original form. The resulting structure is:

```
-----BEGIN PGP SIGNED MESSAGE-----
[Original Data]
-----BEGIN PGP SIGNATURE-----
[Signature in Base64]
-----END PGP SIGNATURE-----
```

This is useful if the original data is readable by a human, and is for example recommended when signing a Security.txt.

In case of the "message" variant, the data is instead encoded in Base64 and combined with the signature. The output will then instead be of the form:

```
-----BEGIN PGP MESSAGE-----
[Data and Signature in Base64]
-----END PGP MESSAGE-----
```

This is more compact, but a human cannot read the original data before decoding it.

### Signing Data

To create an inline signature of (for example) a text file, call:

{{< example sq_sign_inline >}}

This tells Sequoia-PGP to sign the contents of "message.txt", using the secret key in "example_secret.key", and storing the result in "signed_message.txt".

The "cleartext" parameter specifies that the original data is included in the output in its original form (see [above](#cleartext-vs-message)). 

If you do not want to include the data in the output but instead create a separate signature file, call:

{{< example sq_sign_signature_file >}}

The [documentation](https://book.sequoia-pgp.org/signing.html) contains more variants for creating signatures.

### Verifying Signatures

Verifying a separate signature file is very straightforward:

{{< example sq_verify_inline >}}

This command specifies the file containing the original message, the corresponding signature file, and the file containing the public key of the signer.

Verifying an inline signature works similarly:

{{< example sq_verify_signature_file >}}

The "cleartext" option tells Sequoia-PGP that the signed_message.txt contains the original message in clear text (see [above](#cleartext-vs-message)).

> If your assumption about the format is wrong, Sequoia-PGP will notice and correct it for you. Why is the parameter still required, when all the information is already stored in the message? Probably historical reasons.

The command prints the original message to the standard output, and the evaluation (signature is valid / invalid) to standard error. If you only care for the evaluation, append " > /dev/null" to the command above to ignore the standard output.
