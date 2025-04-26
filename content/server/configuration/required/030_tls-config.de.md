+++
title = "TLS-Konfiguration"
slug = "tls-config"
weight = 30
description = "Erfahren Sie, wie Sie TLS für Ihren BOMnipotent-Server konfigurieren, um sichere HTTPS-Verbindungen zu gewährleisten. Schritt-für-Schritt-Anleitung inklusive."
+++

> Die TLS-Konfiguration **unterstützt kein** Hot Reloading. Sie müssen den Server nach der Änderung neu starten.

## Was ist TLS?

> Dieser Abschnitt soll Personen, die noch nie mit TLS zu tun hatten, ein allgemeines Verständnis des Prozesses vermitteln. Sie können gerne direkt zum [Abschnitt über die Konfiguration](#tls-konfiguration) springen.

Transport Layer Security (TLS), manchmal auch mit seinem alten Namen Secure Socket Layer (SSL) bezeichnet, ist für das "S" in "HTTPS" verantwortlich. Es ist eine sehr ausgereifte, intelligente und weit verbreitete Methode zur Ende-zu-Ende Verschlüsselung der Kommunikation über das Internet. Es kann aber auch zu viel Kopfzerbrechen führen.

Grob umrissen funktioniert TLS wie in den folgenden Absätzen beschrieben:

Ihr Server generiert ein Paar aus geheimem und öffentlichem Schlüssel. Jeder kann den öffentlichen Schlüssel verwenden, um entweder eine Nachricht zu *ver*schlüsseln, die nur der geheime Schlüssel *ent*schlüsseln kann, oder um eine Nachricht zu *ent*schlüsseln, die mit dem geheimen Schlüssel *ver*schlüsselt wurde.

Wenn ein Client Ihren Server kontaktiert und um Verschlüsselung bittet, antwortet dieser mit dem Senden eines TLS-Zertifikats. Es enthält mehrere wichtige Felder:
- Den öffentlichen Schlüssel Ihres Servers, mit dem der Client nun Nachrichten senden kann, die nur der Server lesen kann.
- Die Domäne(n), für die dieses Zertifikat gültig ist. Diese werden normalerweise im Feld "Subject Alternative Names" (SAN) gespeichert und sollen sicherstellen, dass der Client wirklich mit der Adresse kommuniziert, die er erreichen wollte.
- Eine digitale Signatur, die kryptografisch beweist, dass das Zertifikat unterwegs nicht verändert wurde.
- Vieles mehr. Sehen Sie sich einfach ein beliebiges Zertifikat in Ihrem Browser an.

Die digitale Signatur wird *nicht* mit dem geheimen Schlüssel des Servers erstellt, da der Client diesem Schlüssel noch nicht vertraut. Stattdessen sind auf Ihrem Computer einige (mehrere hundert) öffentliche Schlüssel gespeichert, die zu sogenannten "Root Certificate Authorities" oder "Stammzertifizierungsstellen" gehören. Ihre Aufgabe ist es, Serverzertifikate zu signieren, nachdem sie überprüft haben, dass der Inhaber des geheimen Schlüssels auch der Besitzer der Domänen ist, auf die sie Anspruch erheben.

Aus praktischen Gründen signieren die Stammzertifizierungsstellen normalerweise kein Serverzertifikat direkt, sondern ein Zwischenzertifikat, welches dann zum Signieren des endgültigen Zertifikats verwendet wird.

Insgesamt sieht die Vertrauenskette also folgendermaßen aus:
1. Der Client vertraut der Stammzertifizierungsstelle.
1. Die Stammzertifizierungsstelle vertraut der Zwischenzertifizierungsstelle.
1. Die Zwischenzertifizierungsstelle vertraut dem Server.

Daher entscheidet sich der Client, dem Server zu vertrauen und eine verschlüsselte Verbindung aufzubauen.

## TLS-Konfiguration

Da BOMnipotent dem Secure-by-Default Prinzip folgt, fordert es von Ihnen mindestens eine Aussage zur TLS-Verschlüsselung. Der Abschnitt "tls" Ihrer [Konfigurationsdatei](/de/server/configuration/config-file/) akzeptiert die folgenden Felder:

```toml
[tls]
allow_http = false # Optional, ist standardmäßig false
certificate_chain_path = „your-chain.crt“
secret_key_path = „your-key.pem“
```

Die Angabe der TLS-Zertifikatpfade ist *erforderlich*, falls HTTP nicht erlaubt ist (da der Server sonst keine Verbindung anbieten könnte), und *optional*, falls HTTP ausdrücklich erlaubt ist, indem [allow_http](#allow_http) auf true gesetzt wird. Wenn Sie entweder den [certificate_chain_path](#certificate_chain_path) oder den [secret_key_path](#secret_key_path) festlegen, müssen Sie auch den jeweils anderen Wert festlegen. Darüber hinaus prüft der Server, ob Zertifikat und Schlüssel zusammenpassen.

### allow_http

Wenn Sie dieses optionale Feld auf true setzen, lässt Ihr BOMnipotent-Server eine unverschlüsselte Verbindungen zu. Dies ist sinnvoll, falls Ihr Server hinter einem Reverse-Proxy läuft und nur über das lokale Netzwerk mit ihm kommuniziert. In diesem Setup ist der Server nicht direkt vom Internet aus erreichbar, sodass der Reverse-Proxy die Verschlüsselung für ihn übernehmen kann.

> Der Default Port für HTTP ist 8080, er kann aber [frei konfiguriert](/de/server/configuration/optional/port-binding/) werden.

Bitte beachten Sie, dass der [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#713-requirement-3-tls) erfordert, dass der Zugriff auf Ihre CSAF-Dokumente verschlüsselt ist!

### secret_key_path

Der Wert von "secret_key_path" muss auf eine Datei verweisen, die für den BOMnipotent-Server erreichbar ist. Ein gängiger Wert ist:
```toml
secret_key_path = "/etc/ssl/private/<Ihre-Domain>_private_key.key"
```

> Wenn Ihr BOMnipotent-Server in einem Docker Container ausgeführt wird, möchten Sie vermutlich das Containerverzeichnis "/etc/ssl" an das gleichnamige Verzeichnis auf dem Host binden.

Die Datei muss ein [ASCII-geschützter](https://openpgp.dev/book/armor.html) geheimer Schlüssel im [PEM-Format](https://de.wikipedia.org/wiki/Privacy_Enhanced_Mail) sein. Glücklicherweise ist dies das Format, in dem TLS Zertifikate üblicherweise ausgestellt werden.

Der Inhalt der Datei könnte beispielsweise so aussehen:
``` {wrap="false" title="geheimer Schlüssel"}
-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEIHru40FLuqgasPSWDuZhc5b2EhCGGcVC+j3DuAqiw0/m
-----END PRIVATE KEY-----
```

> Dies ist der geheime Schlüssel aus einem Zertifikat, das für die BOMnipotent Integrationstests generiert wurde.

### certificate_chain_path

Ebenso muss der "certificate_chain_path" auf eine Datei verweisen, die durch BOMnipotent Server gelesen werden kann. Ein typischer Speicherort ist:
```toml
certificate_chain_path = „/etc/ssl/certs/<Ihre-Domain>-fullchain.crt“
```

Die Kette muss alle Zertifikate in der Vertrauenskette zusammengefügt enthalten, **beginnend** mit dem Zertifikat für **Ihren Server** und **endend** mit der **Stammzertifizierungsstelle**.

Der Inhalt der vollständigen Zertifikatskette für den Integrationstest sieht folgendermaßen aus:
``` {wrap="false" title="Zertifikatskette"}
-----BEGIN CERTIFICATE-----
MIIB8jCCAaSgAwIBAgIBAjAFBgMrZXAwPTELMAkGA1UEBhMCREUxHDAaBgNVBAoT
E0JPTW5pcG90ZW50IFRlc3QgQ0ExEDAOBgNVBAMTB1Rlc3QgQ0EwHhcNMjUwMzA1
MTMxNzEwWhcNMjUwNDI0MTMxNzEwWjBFMQswCQYDVQQGEwJERTEgMB4GA1UEChMX
Qk9Nbmlwb3RlbnQgVGVzdCBTZXJ2ZXIxFDASBgNVBAMTC1Rlc3QgU2VydmVyMCow
BQYDK2VwAyEAMzw8ZVgiuP3bSwh+xcBXu62ORwakr/D+s0XQks1BTFOjgcAwgb0w
DAYDVR0TAQH/BAIwADBIBgNVHREEQTA/gglsb2NhbGhvc3SCCTEyNy4wLjAuMYIT
c3Vic2NyaXB0aW9uX3NlcnZlcoISYm9tbmlwb3RlbnRfc2VydmVyMBMGA1UdJQQM
MAoGCCsGAQUFBwMBMA4GA1UdDwEB/wQEAwIGwDAdBgNVHQ4EFgQUC/RAGubXMfx1
omYTXChtqneWDLcwHwYDVR0jBBgwFoAUStstIFLzDjBSHYSsSr9hSgRVZT4wBQYD
K2VwA0EAXN/6PpJQ0guaJq67kdKvPhgjWVdfxxeCAap8i24R39s7XxNz5x5lPyxA
DQG63NS/OED43+GfpkUguoKxfZLBBA==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIBazCCAR2gAwIBAgIBATAFBgMrZXAwPTELMAkGA1UEBhMCREUxHDAaBgNVBAoT
E0JPTW5pcG90ZW50IFRlc3QgQ0ExEDAOBgNVBAMTB1Rlc3QgQ0EwHhcNMjUwMzA1
MTMxNzEwWhcNMjUwNjEzMTMxNzEwWjA9MQswCQYDVQQGEwJERTEcMBoGA1UEChMT
Qk9Nbmlwb3RlbnQgVGVzdCBDQTEQMA4GA1UEAxMHVGVzdCBDQTAqMAUGAytlcAMh
AIoFFlU/ADa77huqAb5aBY9stDwzzDd/Tdocb9RZDBG2o0IwQDAPBgNVHRMBAf8E
BTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUStstIFLzDjBSHYSsSr9h
SgRVZT4wBQYDK2VwA0EARYL+v9oDGjaSW5MhjjpQUFXnAVMFayaKFfsfbbkmTkv4
+4SRWFb4F/UULlbbvlskSgt8jAaaTSk7tu/iX67YDw==
-----END CERTIFICATE-----
```

Das erste Zertifikat ("MIIB8j...") authentifiziert den Server, das zweite ("MIIBaz...") ist das der Stammzertifizierungsstelle.

> Eine Zwischenzertifizierungsstelle gibt es hier nicht, da sie für die Tests nicht benötigt wird. In Ihrer Produktivumgebung mit echten Zertifikaten müssen Sie höchstwahrscheinlich ein Zwischenzertifikat in der Mitte einfügen.
