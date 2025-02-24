+++
title = "Sicherheitslücken"
slug = "vulnerabilities"
weight = 30
+++

Um eine Liste bekannter Sicherheitslücken anzuzeigen, die ein Produkt betreffen, rufen Sie "vulnerability", "list" sowie den Namen und die Version des Produkts auf:

```bash
bomnipotent_client vulnerability list vulny 0.1.0
```

``` {wrap="false" title="output"}
╭─────────┬─────────┬─────────────────────┬───────────────────────────┬───────┬──────────┬─────────┬─────────────────╮
│ Product │ Version │ Vulnerability       │ Description               │ Score │ Severity │ TLP     │ CSAF Assessment │
├─────────┼─────────┼─────────────────────┼───────────────────────────┼───────┼──────────┼─────────┼─────────────────┤
│ vulny   │ 0.1.0   │ GHSA-qg5g-gv98-5ffh │ rustls network-reachable  │       │ medium   │ Default │                 │
│         │         │                     │ panic in `Acceptor::accep │       │          │         │                 │
│         │         │                     │ t`                        │       │          │         │                 │
╰─────────┴─────────┴─────────────────────┴───────────────────────────┴───────┴──────────┴─────────┴─────────────────╯

```

Die Ausgabe enthält eine ID für die Schwachstelle, eine Beschreibung sowie, und, falls verfügbar, einen  [CVSS Wert](https://www.first.org/cvss/) und/oder eine Schweregrad-Einstufung. Zudem enthält sie eine [TLP Klassifizierung](https://www.first.org/tlp/), welche sich von der des betroffenen Produkts ableitet, und idealerweise eine [CSAF Bewertung](https://www.csaf.io/) durch den Anbieter.

Das CSAF-Dokument ist ein entscheidender Bestandteil, da es Ihnen als Nutzer des Produkts mitteilt, wie Sie auf diese Schwachstelle in der Lieferkette reagieren sollten. Lesen Sie den [nächsten Abschnitt](/de/client/consumer/csaf-docs/), um herauszufinden, wie Sie darauf zugreifen können.
