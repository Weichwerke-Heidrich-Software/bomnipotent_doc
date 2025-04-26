+++
title = "DOS Prevention"
slug = "dos-prevention"
weight = 60
description = "Learn how to fine-tune your DOS prevention in BOMnipotent Server."
+++

Denial of Service (DOS) attacks target programs or servers with the goal of making them unresponsive. They are notoriously hard to mitigate, because they are often based on flooding the service with otherwise legitimate requests.

BOMnipotent has several DOS prevention mechanisms in place (from disallowing any code that might crash the server to limiting the length of log outputs), but one particular technique can be tweaked by the user.

If the number of requests from a single source exceeds a limit within a time period, that source is put on a greylist for one hour, which automatically denies requests.

By default, this happens if the number of requests exceeds 100 within one minute, but you can modify this behaviour in your config file:
```toml
[dos_prevention]
limit = 50 # Default is 100
period = "30 seconds" # Default is "1 minute"
```

This new config would make the server react faster to a possible DOS attack, but has a higher risk to falsely classify request as an attack.
