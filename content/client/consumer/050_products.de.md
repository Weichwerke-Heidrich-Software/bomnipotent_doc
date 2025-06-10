+++
title = "Produkte"
slug = "products"
weight = 50
description = "Produktliste eines CSAF Dokuments mit Befehlsanleitung und tabellarischer Ausgabe der Produkte, deren Schwachstellen, Status, CSAF ID und TLP."
+++

## Auflisten

Um genau zu sehen, welche Produkte von welchem CSAF Dokument behandelt werden, führen Sie den folgenden Befehl aus:

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

Der Befehl akzeptiert die optionalen Filter "name", "vulnerability", "status" und "csaf":

{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client product list --name="CSAF Tools CVRF-CSAF-Converter 1.0.0-alpha" --vulnerability=CVE-2022-27193 --status=known_affected --csaf=BSI-2022-0001
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client product list -n "CSAF Tools CVRF-CSAF-Converter 1.0.0-alpha" -v CVE-2022-27193 -s known_affected -c BSI-2022-0001
```
{{% /tab %}}
{{< /tabs >}}

``` {wrap="false" title="Ausgabe"}
╭───────────────────────────┬────────────────┬────────────────┬───────────────┬───────────╮
│ Product                   │ Vulnerability  │ Status         │ CSAF ID       │ TLP       │
├───────────────────────────┼────────────────┼────────────────┼───────────────┼───────────┤
│ CSAF Tools CVRF-CSAF-Conv │ CVE-2022-27193 │ known_affected │ BSI-2022-0001 │ TLP:WHITE │
│ erter 1.0.0-alpha         │                │                │               │           │
╰───────────────────────────┴────────────────┴────────────────┴───────────────┴───────────╯
```

## Existenz

{{< exists-subcommand-de >}}

{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client product exists --status=known_affected
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client product exists -s known_affected
```
{{% /tab %}}
{{< /tabs >}}
