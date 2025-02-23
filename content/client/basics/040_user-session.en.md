+++
title = "User Session"
slug = "user-session"
weight = 40
+++

## Login

The BOMnipotent Client offers several global optional arguments. To avoid having to provide these time and time again, you can use the login command to store them in a user session:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --domain=<server> --email=<your-email> --output=<mode> --secret-key=<path/to/key> --trusted-root=<path/to/cert> login
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -d <server> -e <your-email> -o <mode> -s <path/to/key> -t <path/to/cert> login
```
{{% /tab %}}
{{< /tabs >}}

This will create a file in the local user folder which stores the provided parameters.
```
[INFO] Storing session data in /home/simon/.config/bomnipotent/session.toml
```

Whenever you call the BOMnipotent Client from now on, it will use these parameters automatically:

```bash
bomnipotent_client bom list # Will automatically reach out to the provided domain and use your authentication data.
```

## Overwriting Parameters

If you are logged in and provide any of the global optional parameters to a BOMnipotent Client call, it will use these instead:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --domain=<other-server> bom list # Will contact other-server
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -d <other-server> bom list # Will contact other-server
```
{{% /tab %}}
{{< /tabs >}}

To permanently change the data stored in the session, simply login again with the new parameters.

This can also be used to remove parameters, simply by not providing them:
{{< tabs >}}
{{% tab title="long" %}}
```bash
bomnipotent_client --domain=<other-server> --email=<your-email> --output=<mode> login # Will set secret-key and trusted-root to none.
```
{{% /tab %}}
{{% tab title="short" %}}
```bash
bomnipotent_client -d <other-server> -e <your-email> -o <mode> login # Will set secret-key and trusted-root to none.
```
{{% /tab %}}
{{< /tabs >}}

## Logout

To remove all parameters, call logout:
```bash
bomnipotent_client logout
```
This will remove the session file.
