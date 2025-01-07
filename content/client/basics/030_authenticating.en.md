+++
title = "Authenticating"
slug = "authenticating"
weight = 30
draft = true
+++

> Authentication requires that you have [requested a user account](/client/basics/account-creation/), and that it has [been approved](/client/system-manager/user-management/user-approval/) by a user manager.

Once your account (meaning your email and public key) is approved, you can provide your email to Bomnipotent Client to make a request that can be authenticated by the server:
```bash
bomnipotent_client --domain=<server> --email=<your-email> <command>
```

BOMnipotent Client then automatically reads your secret key and uses it for authentication.

> Your secret key is used to cryptographically sign the HTTP method, your email, a timestamp and the request body. This simultaneously protects your request against others impersonating you, malicious modifications and replay attacks. The secret key achieves all that without ever having to leave your local computer, the beauty of which is, sadly, beyond the scope of this documentation.

If you are not storing your keys in the default user location, you have to tell BOMnipotent Client the path to it via a command line option:
```bash
bomnipotent_client --domain=<server> --email=<your-email> --secret-key-path=<path/to/key> <command>
```
