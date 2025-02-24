+++
title = "Produktlisten"
slug = "products"
weight = 50
+++

Um genau zu sehen, welche Produkte von einem CSAF Dokument behandelt werden, führen Sie den folgenden Befehl aus:

```bash
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

