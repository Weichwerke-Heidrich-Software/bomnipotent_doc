+++
title = "CSAF-Provider Metadaten"
slug = "provider-metadata"
weight = 50
description = "Erfahren Sie, wie Sie CSAF-Provider-Metadaten gemäß OASIS-Standard mit BOMnipotent einfach generieren oder bereitstellen können."
+++

Der [OASIS-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#717-requirement-7-provider-metadatajson) erfordert, dass Anbieter von CSAF-Dokumenten eine "provider-metadata.json" anbieten, die einem [bestimmten Schema](https://docs.oasis-open.org/csaf/csaf/v2.0/provider_json_schema.json) folgen muss.

BOMnipotent ist bestrebt, die Erfüllung dieser Anforderung so einfach wie möglich zu machen. Sie können entweder die Datei aus einigen wenigen Eingaben [generieren](#daten-generieren) oder eine Datei [bereitstellen](#dateipfad-angeben), welche BOMnipotent laden kann.

## Daten generieren

Durch die Bereitstellung einiger benutzerspezifischer Eingaben können Sie BOMnipotent dazu bringen, eine gültige provider-metadata.json Datei zu generieren. Dies ist viel einfacher als die Datei manuell zu erstellen, bietet aber etwas weniger Kontrolle.

Der relevante Abschnitt in Ihrer Konfigurationsdatei sieht folgendermaßen aus:
```toml
[provider_metadata.publisher]
name = "<Name Ihrer Organisation>"
namespace = "https://<Ihre Domain>.<Top-Level>"
category = "vendor"
issuing_authority = "<Zusätzliche Informationen>" # Optional
contact_details = "<Bitte kontaktieren Sie uns unter...>" # Optional
```

### Dateneingaben des Herausgebers

#### Name

In diesem Feld müssen Sie den Namen Ihres Unternehmens, Ihrer Organisation oder Ihren Namen als Einzelperson angeben.

#### Namespace

Während das Feld "name" in erster Linie für Menschen gedacht ist, wird der "namespace" von Maschinen verwendet, um Ihre Organisation in verschiedenen Sicherheitsdokumenten zu identifizieren. Er muss im URI-Format vorliegen, einschließlich Protokoll, Domäne und Top-Level-Domäne. Da er sich auf Ihre gesamte Organisation bezieht, sollte er keine Subdomäne enthalten.

> Das ist, was das Feld "provider_metadata.publisher.namespace" von der Konfiguration ["domain"](/de/server/configuration/required/domain/) unterscheidet: Letztere verweist auf Ihre Instanz von BOMnipotent Server, während Erstere viel allgemeiner ist.

#### Kategorie

Die Herausgeberkategorie ist eine maschinenlesbare Klassifizierung Ihrer Organsiation. Gemäß dem [CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#32181-document-property---publisher---category) sind in den Herausgeberkategorien die Werte "coordinator", "discoverer", "other", "translator", "user" oder "vendor" zulässig. Als Benutzer von BOMnipotent Server sind Sie höchstwahrscheinlich ein "vendor", also ein Entwickler oder Weiterverkäufer von Produkten oder Dienstleistungen.

#### Issuing Authority / Ausstellerinformation

Das optionale Feld "issuing_authority" kann verwendet werden, um Ihre Verbindung zu den gehosteten Dokumenten zu verdeutlichen. Sind Sie der Entwickler? Sind Sie ein Händler? Die Eingabe ist in freier Form.

#### Kontaktdaten

In dem optionalen Feld "contact_details" können Sie Kontaktdaten für allgemeine oder Sicherheitsanfragen angeben. Die Eingabe ist in freier Form.

### Generiertes Dokument

Sobald Sie die Daten bereitgestellt und den Server gestartet haben, wird das generierte Dokument unter "Ihre-Domain/.well-known/csaf/provider-metadata.json" gehostet. Sie können [hier](https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json) ein Live-Beispiel und hier ein statisches Beispiel sehen:
```json {wrap="false" title="provider-metadata.json"}
{
    "canonical_url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json",
    "distributions": [
        {
            "rolie": {
                "feeds": [
                    {
                        "summary": "WHITE advisories",
                        "tlp_label": "WHITE",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/white/csaf-feed-tlp-white.json"
                    },
                    {
                        "summary": "GREEN advisories",
                        "tlp_label": "GREEN",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/green/csaf-feed-tlp-green.json"
                    },
                    {
                        "summary": "AMBER advisories",
                        "tlp_label": "AMBER",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/amber/csaf-feed-tlp-amber.json"
                    },
                    {
                        "summary": "RED advisories",
                        "tlp_label": "RED",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/red/csaf-feed-tlp-red.json"
                    },
                    {
                        "summary": "UNLABELED advisories",
                        "tlp_label": "UNLABELED",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/unlabeled/csaf-feed-tlp-unlabeled.json"
                    }
                ]
            }
        }
    ],
    "last_updated": "2025-03-06T16:13:24.632235974Z",
    "list_on_CSAF_aggregators": true,
    "metadata_version": "2.0",
    "mirror_on_CSAF_aggregators": true,
    "publisher": {
        "category": "vendor",
        "contact_details": "For security inquiries, please contact info@wwh-soft.com",
        "name": "Weichwerke Heidrich Software",
        "namespace": "https://wwh-soft.com"
    },
    "role": "csaf_provider"
}
```

Diese Datei enthält einen [ROLIE-Feed](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#7115-requirement-15-rolie-feed) für alle Ihre CSAF-Dokumente, was wahrscheinlich der Hauptgrund ist, warum Sie dieses Dokument nicht von Hand erstellen möchten.

Das Feld "last_updated" wird aus dem letzten Modifizierungszeitstempel Ihrer Konfigurationsdatei generiert.

BOMnipotent geht davon aus, dass Sie Ihre CSAF-Dokumente auf öffentlich verfügbaren Repositorien aufgelistet und gespiegelt haben möchten. Dies betrifft nur die mit {{<tlp-white>}} / {{<tlp-clear>}} gekennzeichneten Dokumente! Die Aggregatoren haben keinen Zugriff auf anderweitig klassifizierte Dokumente.

BOMnipotent hilft Ihnen, alle Anforderungen zu erfüllen, um ein [CSAF-Anbieter](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider) gemäß dem OASIS-Standard zu sein.

## Dateipfad angeben

Wenn Sie aus irgendeinem Grund die vollständige Kontrolle über das Dokument mit den Anbietermetadaten haben möchten, können Sie in der Konfigurationsdatei einen Dateipfad angeben:

```toml
[provider_metadata]
path = "<Dateipfad>"
```

BOMnipotent ließt dann die Datei, überprüft, ob sie dem [Anbietermetadaten-JSON-Schema](https://docs.oasis-open.org/csaf/csaf/v2.0/provider_json_schema.json) entspricht, und hostet sie.

Sie müssen **entweder** einen Pfad zu einer Datei **oder** Herausgeberdaten angeben. Wenn Sie keines oder beides angeben, wird die Konfiguration nicht geladen.
