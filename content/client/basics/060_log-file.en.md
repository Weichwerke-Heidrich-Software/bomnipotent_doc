+++
title = "Log File"
slug = "log-file"
weight = 60
description = "Learn how to store BOMnipotent Client log output in a file, manage log file overwriting, and handle log file configurations effectively."
+++

To store the log output of a call to BOMnipotent Client in a file instead of printing it to stdout, call

{{< example log_file >}}

The output is the same, except that the stdout output is coloured according to its severity level, while the file output is not.

If BOMnipotent Client is called repeatedly with the same log-file, it will **overwrite** the existing contents, **if** the existing file looks like a log-file.

> A file looks like a log-file to BOMnipotent if it is either empty or contains at least one of the strings "[ERROR]", "[WARN]", "[INFO]", "[DEBUG]" or "[TRACE]".

If an existing file does not look like a log-file, BOMnipotent gets cautious and aborts:

{{< example log_file_abort >}}

Because the commands ["bom get"](/client/consumer/boms/#get) / ["csaf get"](/client/consumer/csaf-docs/#get) as well as the "fetch" command are meant for machine-processing, they print their output to stdout **even if a log-file is configured**. This separation of outputs makes it possible to simultaneously process the data and store potential error messages.
