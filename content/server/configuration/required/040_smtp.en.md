+++
title = "SMTP Settings"
slug = "smtp"
weight = 40
+++

Simple Mail Transfer Protocol (SMTP) is the protocol used for sending emails. In the context of BOMnipotent, the server uses it to verify that newly requested users have access to the email address they provided. To enable the server to do that, it needs to be taught to reach an SMTP endpoint.

## Configuring SMTP

The smtp section of the configuration file looks like this:
```toml
[smtp]
user = "you@yourdomain.com"
endpoint = "your.smtp.host"
secret = "${SMTP_SECRET}" # Optional
starttls = true # Optional, defaults to false
```

### Inputs

#### User

The SMTP user is the email address you use when authenticating with your mail server.

#### Endpoint

The SMTP endpoint tells BOMnipotent where to send the data to. It can point directly to your mailserver, or to an SMTP relay.

If the endpoint begins with the "smtp://" marker, BOMnipotent Server will try to directly connect to that URL. This is typically what you want when connecting to a locally running relay. Otherwise, it will connect to an external relay.

#### Secret

When directly communicating with your mailserver, you have to authenticate. The secret will either be your password, or an API key if your mail provider offers one. In the example above, the secret is read from an environmen variable called "SMTP_SECRET", which could for example come from a .env file.

A locally running SMTP relay does not necessarily require a password to accept mails, which is why this field is optional.

#### STARTTLS

STARTTLS is one option to encrypt sending emails, the other being SMTPS. Since 2018, the Internet Engineering Task Force [recommends against using STARTTLS](https://datatracker.ietf.org/doc/html/rfc8314). However, if your mailserver does not support SMTPS, STARTTLS is better than no encryption, which is why it is still supported by BOMnipotent Server.

## Skipping User Verification

If you do not (yet) have access to an SMTP server, you can eliminate the need for the smtp configuration by adding the following line to the global context (meaning at the beginning) of your config.toml:

```toml
skip_user_verification = true
```

BOMnipotent Server will then *not* send a verification email to newly requested users. It will instead log a warning message each time it does *not* send said mail, because this configuration reduces the security of your server.
