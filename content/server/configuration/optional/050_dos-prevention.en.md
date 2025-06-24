+++
title = "DoS Prevention"
slug = "dos-prevention"
weight = 50
description = "Learn how to fine-tune your DoS prevention in BOMnipotent Server."
+++

Denial of Service (DoS) attacks target programs or servers with the goal of making them unresponsive. They are notoriously hard to mitigate, because they are often based on flooding the service with otherwise legitimate requests.

BOMnipotent has several DoS prevention mechanisms in place (from disallowing any code that might crash the server to limiting the length of log outputs). Some techniques can be tweaked by the user.

## User-specific DoS Prevention

If the number of requests from a single source exceeds a limit within a time period, that source is put on a greylist for one hour, which automatically denies requests.

By default, this happens if the number of requests exceeds 100 within one minute, but you can modify this behaviour in your config file:
```toml
[dos_prevention]
limit = 50 # Default is 100
period = "30 seconds" # Default is "1 minute"
```

This new config would make the server react faster to a possible DoS attack, but has a higher risk to falsely classify request as an attack.

## Global Request User DoS Prevention

The HTTP request for creating a new user is typically not associated with any existing user. The user-specific does prevention still uses the IP address of the request, but this does not prevent from IP spoofing or distributed DoS attacks. It further offers an attacker the possibility to modify the database by adding keys.

On the bright side, the request for a new user is something that is not expected to happen exceedingly often. This is why a global limit on requests for users exists. Its default values are much stricter, but they, too, can be modified:
```toml
[new_user_dos_prevention]
limit = 10 # Default is 3
period = "20 seconds" # Default is "10 seconds"
```

Because the request can not reliably be associated with a source, no greylisting happens here.
