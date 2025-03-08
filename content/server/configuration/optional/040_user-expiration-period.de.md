+++
title = "Benutzergültigkeitszeitraum"
slug = "user-expiration-period"
weight = 40
+++

Wenn eine Anfrage für ein neues [Benutzerkonto](/de/client/basics/account-creation/) gestellt wird, wird ein öffentlicher Schlüssel in der Datenbank hinterlegt.

Dieser Schlüssel hat ein Ablaufdatum, nach dem er nicht mehr akzeptiert wird. Dieses können Sie sich anzeigen lassen:
```bash
./bomnipotent_client user list
```
``` {wrap="false" title="output"}
╭───────────────────┬──────────┬───────────────────────────┬───────────────────────────╮
│ User Email        │ Status   │ Expires                   │ Last Updated              │
├───────────────────┼──────────┼───────────────────────────┼───────────────────────────┤
│ info@wwh-soft.com │ APPROVED │ 2026-03-03 11:30:15.62432 │ 2025-03-02 11:47:38.51048 │
│                   │          │ 5 UTC                     │ 5 UTC                     │
╰───────────────────┴──────────┴───────────────────────────┴───────────────────────────╯
```

Standardmäßig ist der Schlüssel nach der Anforderung etwas mehr als ein Jahr lang gültig. Diese Zeit kann mit dem Parameter "user_expiration_period" konfiguriert werden. Als Werte akzeptiert er einen Zeitraum im menschenlesbaren Format „<Zahl> <Einheit>“, wobei „<Einheit>“ die englische Zeitangabe "year", "month", "week", "day" oder deren Pluralvarianten sein kann.
{{< tabs >}}
{{% tab title="Default" %}}
```toml
user_expiration_period = "366 days"
```
{{% /tab %}}
{{% tab title="mehrere Jahre" %}}
```toml
user_expiration_period = "5 years"
```
{{% /tab %}}
{{% tab title="ein Monat" %}}
```toml
user_expiration_period = "1 month"
```
{{% /tab %}}
{{% tab title="drei Wochen" %}}
```toml
user_expiration_period = "3 weeks"
```
{{% /tab %}}
{{% tab title="fünf Tage" %}}
```toml
user_expiration_period = "5 days"
```
{{% /tab %}}
{{< /tabs >}}

> Falls Sie Ihre Benutzer wirklich hassen, können Sie auch "hours", "minutes", seconds", "ms", "us" oder "ns" als Einheit verwenden. BOMnipotent stellt nicht in Frage, wie realistisch Ihre Erwartungen sind.

Das Ändern dieser Konfiguration **hat keine** Auswirkungen auf die Ablaufdaten bestehender Benutzer! Es beeinflusst nur, wie viel Zeit neu angeforderten Benutzern eingeräumt wird.
