+++
title = "User Session"
slug = "user-session"
weight = 40
description = "Guide on managing user sessions in the BOMnipotent Client, including login, overwriting parameters, checking status, and logout."
+++

## Login

The BOMnipotent Client offers several global optional arguments. To avoid having to provide these time and time again, you can use the login command to store them in a user session. This will create a file in the local user folder which stores the provided parameters:

{{< example session_login >}}

Whenever you call the BOMnipotent Client from now on, it will use these parameters automatically.

Any relative filepaths you provide will be resolved to absolute paths before storing them. This way, the session data can be used from anywhere on your computer.

## Overriding and Overwriting

If you are logged in and provide any of the global optional parameters to a BOMnipotent Client call, it will use these instead:

{{< example session_override >}}

To permanently change the data stored in the session, simply login again with the new parameters.

This can also be used to remove parameters, simply by not providing them:

{{< example session_remove_parameters >}}

## Status

To print the current parameters of your session, call "session status". The output is in [TOML format](https://toml.io/en/) (which is also how it is stored on your filesystem):

{{< example session_status >}}

If you prefer JSON, merely append the "--json" option:

{{< example session_status_json >}}

If you are not logged in, you get an informational log and an empty TOML/JSON output:

{{< example session_status_not_logged_in >}}

{{< example session_status_not_logged_in_json >}}

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

{{< example session_logout >}}

This will remove the session file.
