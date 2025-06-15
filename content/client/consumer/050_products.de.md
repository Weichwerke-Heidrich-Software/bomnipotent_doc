+++
title = "Produkte"
slug = "products"
weight = 50
description = "Produktliste eines CSAF Dokuments mit Befehlsanleitung und tabellarischer Ausgabe der Produkte, deren Schwachstellen, Status, CSAF ID und TLP."
+++

## Auflisten

Um genau zu sehen, welche Produkte von welchem CSAF Dokument behandelt werden, führen Sie den folgenden Befehl aus:

{{< example product_list >}}

Der Befehl akzeptiert die optionalen Filter "name", "vulnerability", "status" und "csaf":

{{< example product_filtered_list >}}

## Existenz

{{< exists-subcommand-de >}}

{{< example product_exists >}}
