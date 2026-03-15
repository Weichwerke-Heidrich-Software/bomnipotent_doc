+++
title = "CSAFs Herunterladen"
slug = "download_csafs"
weight = 20
+++

Diese Aufgabe lädt CSAF Dokumente von einer externen Quelle, vergleicht diese mit den Komponenten aller gespeicherten BOMs, und erstellt neue Sicherheitslückeneinträge basierend auf den Ergebnissen.

Der Name dieser Aufgabe lautet "download_csafs". Sie akzeptiert die folgenden [Konfigurationen](/de/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "download_csafs"
url = "https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json"
period = "1 day" # Optional
scheduled = true # Optional
trusted_root = "/path/to/tls/certificate" # Optional, zum testen

[[tasks]]
name = "download_csafs"
url = "<other_provider_metadata>"
```

Der "url" Parameter wird benötigt und muss auf die Provider Metadata eines CSAF Servers verweisen. Dieser wird als Einsprungspunkt genutzt, um alle CSAF Dokumente von einem Server aufzusammeln.

Beachten Sie, dass Aufgaben mehrfach mit verschiedenen Parametern konfiguriert werden können. Hierdurch können mehrere verschiedene CSAF Server angefragt werden.

Der "trusted_root" Parameter wird genutzt, um eine verschlüsselte HTTPS Verbindung zu einem Server mit ansonsten ungültigem Zertifikat aufzubauen. Der Parameter existiert ausschließlich, um das Testen des Setups mit gefälschten Zertifikaten zu ermöglichen. Produktiv eingesetzte CSAF Provider müssen ein valides TLS Zertifikat haben, welches von einer offiziellen Root Certificate Authority signiert wurde.
