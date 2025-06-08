+++
title = "Listing Products"
slug = "products"
weight = 50
description = "Listing of products covered by a CSAF advisory, including product names, vulnerabilities, statuses, CSAF IDs, and TLP levels, with command to generate the list."
+++

To see exactly which products are covered by which CSAF advisory, run:

```
./bomnipotent_client product list
```

``` {wrap="false" title="output"}
╭───────────────────────────┬────────────────┬────────────────┬───────────────┬───────────╮
│ Product                   │ Vulnerability  │ Status         │ CSAF ID       │ TLP       │
├───────────────────────────┼────────────────┼────────────────┼───────────────┼───────────┤
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-alpha         │                │                │               │           │
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-dev1          │                │                │               │           │
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-dev2          │                │                │               │           │
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-dev3          │                │                │               │           │
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-rc1           │                │                │               │           │
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ first_fixed    │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-rc2           │                │                │               │           │
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ fixed          │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-rc2           │                │                │               │           │
╰───────────────────────────┴────────────────┴────────────────┴───────────────┴───────────╯
```

The command accepts the optional filters "name", "vulnerability", "status" and "csaf":

{{< tabs >}}
{{% tab title="long" %}}
```
bomnipotent_client product list --name="CSAF Tools CVRF-CSAF-Converter 1.0.0-alpha" --vulnerability=CVE-2022-27193 --status=known_affected --csaf=BSI-2022-0001
```
{{% /tab %}}
{{% tab title="short" %}}
```
bomnipotent_client product list -n "CSAF Tools CVRF-CSAF-Converter 1.0.0-alpha" -v CVE-2022-27193 -s known_affected -c BSI-2022-0001
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="output"}
╭───────────────────────────┬────────────────┬────────────────┬───────────────┬───────────╮
│ Product                   │ Vulnerability  │ Status         │ CSAF ID       │ TLP       │
├───────────────────────────┼────────────────┼────────────────┼───────────────┼───────────┤
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-alpha         │                │                │               │           │
╰───────────────────────────┴────────────────┴────────────────┴───────────────┴───────────╯
```