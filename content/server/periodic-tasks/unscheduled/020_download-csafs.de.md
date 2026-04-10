+++
title = "CSAFs Herunterladen"
slug = "download-csafs"
weight = 20
description = "Prüfen Sie zyklisch externe CSAF Provider, und eröffnen damit einen neuen Pfad, um BOMs mit Sicherheitslücken anzureichern."
+++

Diese Aufgabe lädt CSAF Dokumente von einer externen Quelle, vergleicht diese mit den Komponenten aller gespeicherten BOMs, und erstellt neue [Sicherheitslückeneinträge](/de/client/manager/doc-management/vulnerabilities/#aktualisieren-klassifizierter-sicherheitslücken) basierend auf den Ergebnissen.

Der Name dieser Aufgabe lautet "download_csafs". Sie akzeptiert die folgenden [Konfigurationen](/de/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "download_csafs"
url = "https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json"
client_cert_chain = "/path/to/tls/certificate/chain.pem" # Optional, für mTLS
client_cert_key = "/path/to/tls/secret.key.pem" # Optional, für mTLS
period = "1 day" # Optional
scheduled = true # Optional
trusted_root = "/path/to/tls/certificate" # Optional, zum testen

[[tasks]]
name = "download_csafs"
url = "<other_provider_metadata>"
```

Der "url" Parameter wird benötigt und muss auf die Provider Metadata eines CSAF Servers verweisen. Dieser wird als Einsprungspunkt genutzt, um alle CSAF Dokumente von einem Server aufzusammeln.

Viele CSAF Provider schützen den Zugriff auf CSAF Dokumente mit einer TLP Klassifizierung, welche nicht {{<tlp-white>}}/{{<tlp-clear>}} ist, über Mutual Transport Layer Security (mTLS). Hierbei wird dem Client ein TLS Zertifikat zusammen mit einem geheimen Schlüssel ausgestellt, welches der Client bei Anfragen nutzen kann, um sich zu authentifizieren.

Um der zyklischen Aufgabe Zugriff auf diesen Authentifizierungsmechanismus zu geben, existieren die Argumente "client_cert_chain" und "client_cert_key". Hierüber können ihr eine Zertifikatskette sowie der zugehörige geheime Schlüssel mitgegeben werden.

> Die "Zertifikatskette" enthält das Client Zertifikat und das Zertifikat der Autorität, welches dieses signiert hat. Die Reihenfolge ist dabei aufsteigend, beginnt also mit dem Client Zertifikat.

Die Implementierung von mTLS ermöglicht es, nicht-öffentliche CSAF Dokumente als Grundlage für Sicherheitslücken in den eigenen Produkten zu nutzen.

> Eine Sicherheitslücke entsteht aus dem Abgleich zwischen einem CSAF Dokument und einer BOM. Die resultierende TLP Klassifizierung ist hierbei die strengere der beiden: Wenn eines der Dokumente als {{<tlp-green>}} klassifiziert ist, und eines als {{<tlp-amber>}}, dann wird die Sicherheitslücke immer als {{<tlp-amber>}} klassifiziert.

Beachten Sie, dass Aufgaben mehrfach mit verschiedenen Parametern konfiguriert werden können. Hierdurch können beliebig viele verschiedene CSAF Server angefragt werden.

Der "trusted_root" Parameter wird genutzt, um eine verschlüsselte HTTPS Verbindung zu einem Server mit ansonsten ungültigem Zertifikat aufzubauen. Der Parameter existiert ausschließlich, um das Testen des Setups mit gefälschten Zertifikaten zu ermöglichen. Produktiv eingesetzte CSAF Provider müssen ein valides TLS Zertifikat haben, welches von einer offiziellen Root Certificate Authority signiert wurde.
