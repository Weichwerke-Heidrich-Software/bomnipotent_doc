+++
title = "Authenticating"
slug = "authenticating"
weight = 30
description = "Learn how to authenticate with BOMnipotent Client using your email and secret key, including command examples and handling non-default key storage locations."
+++

> Authentication requires that you have [requested a user account](/client/basics/account-creation/), and that it has [been approved](/client/manager/access-management/user-management/) by a user manager.

Once your account (meaning your username and public key) is approved, you can provide your username to Bomnipotent Client to make a request that can be authenticated by the server:

{{< example authenticated_request >}}

BOMnipotent Client then automatically reads your secret key and uses it for authentication.

> Your secret key is used to cryptographically sign the HTTP method, your username, a timestamp and the request body. This simultaneously protects your request against others impersonating you, malicious modifications and replay attacks. The secret key achieves all that without ever having to leave your local computer, the beauty of which is, sadly, beyond the scope of this documentation.

If you are not storing your keys in the default user location, you have to tell BOMnipotent Client the path to it via a command line option:

{{< example authenticated_request_custom_key >}}

To avoid providing three extra arguments to every single request, you can instead store this data in a [User Session](/client/basics/user-session/).
