+++
title = "Log Level"
slug = "log-level"
weight = 50
description = "Learn how to configure log levels in BOMnipotent Client, including error, warn, info, debug, and trace, with examples and output details."
+++

BOMnipotent Client offers several severity levels of logs:
- error
- warn
- info (default)
- debug
- trace

They can be selected via:

{{< example log_level >}}

This defines the minimum severity level for a message to be logged: Choosing log level debug makes BOMnipotent print all messages of severity error, warn, info and debug, but not trace.

By default, BOMnipotent Client logs messages to stdout, regardless of severity level. You can instruct it to [log to a file](/client/basics/log-file/) instead.

## Info, Warn and Error

The default log-level is info. It prints some information, but does not overwhelm the user.

{{< example "health" >}}

{{< example "bom_list" >}}

## Debug

The debug output mode prints some additional information which may be of interest when looking for the cause of an error in the input or setup:

{{< example health_debug >}}

## Trace

In output mode trace, BOMnipotent additionally prints the module where the log message originated. This is mainly interesting for finding the cause of an error *in the program itself*.

{{< example health_trace >}}
