+++
title = "OpenPGP-Konfiguration"
slug = "open-pgp"
description = "Erfahren Sie, wie Sie OpenPGP-Schlüssel im BOMnipotent Server konfigurieren, um Dokumente zu signieren und als CSAF Trusted Provider aufzutreten."
weight = 35
+++

Dieser Abschnitt beschreibt, wie Sie Ihr OpenPGP Schlüsselpaar Ihrer Instanz von BOMnipotent Server zur Verfügung stellen können. Dies erlaubt ihm, Ihren öffentlichen Schlüssel zu hosten und Ihre Dokumente zu signieren, was notwendig ist, um ein [CSAF Trusted Provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#723-role-csaf-trusted-provider) zu werden.

> Um mehr über OpenPGP im Allgemeinen zu lernen, und wie Sie ein Schlüsselpaar für Ihr Projekt erzeugen können, lesen Sie den [Artikel](/de/integration/open-pgp/) zu diesem Thema.

## OpenPGP Konfiguration

Der "openpgp" Abschnitt Ihrer config.toml akzeptiert die folgenden Felder:

```toml
[open_pgp]
public_key_path = "public_key.asc"
secret_key_path = "secret_key.asc"
passphrase = "${PGP_PASSPHRASE}" # Optional
```

Die Konfigurationen "public_key_path" und "secret_key_path" müssen auf Dateien zeigen, welche jeweils einen ASCII-armoured öffentlichen beziehungsweise geheimen OpenPGP Schlüssel enthalten. Falls Sie dem [Tutorial](/de/integration/open-pgp/) zum Erstellen und Exportieren Ihrer Schlüssel gefolgt sind, wird der Server diese akzeptieren.

> Keine Sorge: Falls Sie die Schlüssel aus Versehen vertauscht haben, weigert sich BOMnipotent, die Konfiguration zu laden, anstatt Ihren geheimen Schlüssel zu leaken.

> [!TIP]
> Falls Sie Ihre Schlüssel neben Ihrer config.toml ablegen, profitieren Sie von BOMnipotent's hot reloading, was bedeutet, dass der Server automatisch aktualisiert wird, sobald Sie Ihre Schlüsseldateien ändern.

Es wird empfohlen, Ihren geheimen Schlüssel mit einer Passphrase zu schützen. Um BOMnipotent zu erlauben, diesen zu benutzen, können Sie diese über die "passphrase" Konfiguration angeben.

> [!NOTE]
> Sie sollten die Passphrase **nicht** direkt in der Konfiguration speichern, sondern sie stattdessen über eine Umgebungsvariable übergeben. In dem Beispiel oben wird "PGP_PASSPHRASE" als der (beliebige) Name der Variable verwendet.

## Vorteile

Bevor BOMnipotent Server die Konfiguration akzeptiert, prüft es sie zuerst auf Konsistenz. Dafür lädt es die Schlüssel, und signiert und verifiziert eine Testnachricht, um zu überprüfen, dass alles seine Richtigkeit hat.

Der Server bietet den öffentlichen Schlüssel daraufhin über die Pfade "\<Ihre-Domain\>/openpgp-key.asc" (den intuitiven Pfad) und "\<your-domain\>/.well-known/csaf/openpgp/openpgp-key.asc" (den vom [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#7120-requirement-20-public-openpgp-key) vorgeschlagenen Pfad) an.

Zu guter Letzt deklariert der Server Sie in Ihrer [Provider Metadata](/de/server/configuration/required/provider-metadata/) als "CSAF trusted Provider".
