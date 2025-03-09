+++
title = "Serverdomäne"
slug = "domain"
weight = 20
description = "Konfigurieren Sie die Serverdomäne für den BOMnipotent-Server, um API-Zugriff und statische Seiten wie CSAF-Provider-Metadaten zu ermöglichen."
+++

Der BOMnipotent-Server ist nicht nur per API erreichbar, sondern zeigt auch einige statische XML- und HTML-Seiten an. Ein wichtiges Beispiel ist, dass er für Sie [CSAF-Provider-Metadaten](/de/server/configuration/required/provider-metadata/) generieren kann. Da einige dieser Seiten aufeinander verweisen, muss der Server die vollständige Domäne kennen, hinter der er vom Internet aus erreichbar ist.

Der Parameter wird einfach "domain" genannt. Die Angabe eines Protokolls ist optional, "https" wird als Default angenommen.

Der entsprechende Teil in der Konfigurationsdatei kann beispielsweise so aussehen:
{{< tabs >}}
{{% tab title="mit Protokoll" %}}
```toml
domain = "https://bomnipotent.wwh-soft.com"
```
{{% /tab %}}
{{% tab title="ohne Protokoll" %}}
```toml
domain = "bomnipotent.wwh-soft.com"
```
{{% /tab %}}
{{< /tabs >}}
