+++
title = "User Session"
slug = "user-session"
weight = 40
description = "Guide on managing user sessions in the BOMnipotent Client, including login, overwriting parameters, checking status, and logout."
+++

## Login

The BOMnipotent Client offers several global optional arguments. To avoid having to provide these time and time again, you can use the login command to store them in a user session:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --domain=<server> --user=<your-email> --output=<mode> --secret-key=<path/to/key> --trusted-root=<path/to/cert> login
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client -d <server> -u <your-email> -o <mode> -s <path/to/key> -t <path/to/cert> login
```
{{% /tab %}}
{{< /tabs >}}

This will create a file in the local user folder which stores the provided parameters.
``` {wrap="false" title="output"}
[INFO] Storing session data in /home/simon/.config/bomnipotent/session.toml
```

Whenever you call the BOMnipotent Client from now on, it will use these parameters automatically:

```
bomnipotent_client bom list # Will automatically reach out to the provided domain and use your authentication data.
```

Any relative filepaths you provide will be resolved to absolute paths before storing them. This way, the session data can be used from anywhere on your computer.

## Overwriting Parameters

If you are logged in and provide any of the global optional parameters to a BOMnipotent Client call, it will use these instead:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --domain=<other-server> bom list # Will contact the other server
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client -d <other-server> bom list # Will contact the other server
```
{{% /tab %}}
{{< /tabs >}}

To permanently change the data stored in the session, simply login again with the new parameters.

This can also be used to remove parameters, simply by not providing them:
{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client --domain=<other-server> --user=<your-email> --output=<mode> login # Will set secret-key and trusted-root to none.
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client -d <other-server> -u <your-email> -o <mode> login # Will set secret-key and trusted-root to none.
```
{{% /tab %}}
{{< /tabs >}}

## Status

To print the current parameters of your session, call:
```
bomnipotent_client session status
```

The output is in [TOML format](https://toml.io/en/) (which is also how it is stored on your filesystem):
``` toml {wrap="false" title="output"}
domain = "https://localhost:62443"
user = "admin@wwh-soft.com"
secret_key_path = "/home/simon/git/bomnipotent/test_cryptofiles/admin"
trusted_root_path = "/home/simon/git/bomnipotent/test_cryptofiles/ca.crt"
```

If you prefer JSON, merely append the "--json" option:
{{< tabs >}}
{{% tab title="long" %}}
```
./bomnipotent_client session status --json
```
{{% /tab %}}
{{% tab title="short" %}}
```
./bomnipotent_client session status -j
```
{{% /tab %}}
{{< /tabs >}}

``` json {wrap="false" title="output"}
{
  "domain": "https://localhost:62443",
  "user": "admin@wwh-soft.com",
  "secret_key_path": "/home/simon/git/bomnipotent/test_cryptofiles/admin",
  "trusted_root_path": "/home/simon/git/bomnipotent/test_cryptofiles/ca.crt"
}
```

If you are not logged in, you get an informational trace and an empty TOML/JSON output:
{{< tabs >}}
{{% tab title="output (toml)" %}}
```
[INFO] No session data is currently stored

```
{{% /tab %}}
{{% tab title="output (json)" %}}
```
[INFO] No session data is currently stored
{}
```
{{% /tab %}}
{{< /tabs >}}

If you would like to use this command to programatically check if session data exists, you can for example use the "raw" output mode to avoid the info trace, and check if the return value is empty:

{{< tabs >}}
{{% tab title="bash" %}}
``` bash
#!/bin/bash

output=$(./bomnipotent_client --output raw session status)
if [ -n "$output" ]; then
    echo "Found session data:"
    echo "$output"
else
    echo "Session not logged in."
fi
```
{{% /tab %}}
{{% tab title="powershell" %}}
``` ps1
$output = ./bomnipotent_client --output raw session status
if ($output) {
    Write-Output "Found session data:"
    Write-Output $output
} else {
    Write-Output "Session not logged in."
}
```
{{% /tab %}}
{{< /tabs >}}



## Logout

To remove all parameters, call logout:
```
bomnipotent_client logout
```
This will remove the session file.
