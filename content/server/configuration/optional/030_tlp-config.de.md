+++
title = "TLP Konfiguration"
slug = "tlp-config"
weight = 30
+++

CSAF-Dokumente können und sollten mit dem [Traffic Light Protocol (TLP)](https://www.first.org/tlp/) klassifiziert werden. Es klärt, ob und mit wem Sie Dokumente teilen können, auf die Sie Zugriff haben. Der etwas ältere TLP v1.0-Standard kennt vier verschiedene Klassifizierungen:
- {{<tlp-red>}}: Dieses Dokument darf nicht an andere weitergegeben werden.
- {{<tlp-amber>}}: Dieses Dokument kann nach dem Need-to-know-Prinzip innerhalb der Organisation und an deren Kunden verbreitet werden.
- {{<tlp-green>}}: Dieses Dokument kann innerhalb der Community des Empfängers verbreitet werden.
- {{<tlp-white>}}: Es gibt keine Einschränkung hinsichtlich der Weitergabe.

Der aktuellere TLP v2.0-Standard ersetzt {{<tlp-white>}} durch {{<tlp-clear>}} und fügt die neue Klassifizierung {{<tlp-amber-strict>}} hinzu, die nur die Weitergabe an die Organisation des Empfängers auf Need-to-know-Basis erlaubt, aber nicht darüber hinaus.

> Von BOMnipotent Server gehostete Dokumente, die als {{<tlp-white>}} oder {{<tlp-clear>}} klassifiziert sind, sind für **jeden** sichtbar, egal ob Administrator, völlig unauthentifizierter Benutzer oder Crawler-Bot!

Der Abschnitt "tlp" Ihrer Konfigurationsdatei kann die folgenden Felder enthalten:
```toml
[tlp]
allow_tlp2 = true # Der Default ist false
default_tlp = "amber+strict" # Der Default ist "red"
```

## TLP v2.0 zulassen

Der aktuelle [OASIS CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#32152-document-property---distribution---tlp) erfordert, dass Dokumente mit einem TLP v1.0 Label klassifiziert werden. Viele Unternehmen würden jedoch lieber die {{<tlp-amber-strict>}} Klassifizierung aus dem TLP v2.0 Standard für ihre Dokumente verwenden. Darüber hinaus wird der TLP v2.0-Standard [verbindlich](https://github.com/oasis-tcs/csaf/pull/720), sobald der CSAF-Standard 2.1 veröffentlicht wird.

Um vollständig mit dem CSAF-Standard kompatibel zu sein, lässt BOMnipotent standardmäßig keine TLP v2.0 Beschriftungen zu. Sie können jedoch das Feld "allow_tlp2" im Abschnitt "tlp" Ihrer Konfigurationsdatei auf "true" setzen:
```toml
[tlp]
allow_tlp2 = true
```

Wenn Sie dies tun, werden sowohl TLP v1.0 als auch TLP v2.0 Label akzeptiert.

Wenn Sie dies hingegen nicht tun und BOMnipotent auf TLP v2.0 Beschriftungen stößt, konvertiert es {{<tlp-clear>}} stillschweigend in {{<tlp-white>}}. Da {{<tlp-amber-strict>}} in TLP v1.0 kein direktes Äquivalent hat, wählt BOMnipotent den konservativen Ansatz, konvertiert es in {{<tlp-red>}} und protokolliert eine Warnung.

## Default-TLP

Die Klassifizierung eines CSAF-Dokuments mit einem TLP-Label ist optional, und eine TLP-Klassifizierung ist nicht einmal Teil des CycloneDX-Standards für BOM-Dokumente. BOMnipotent muss zumindest wissen, ob das Dokument mit {{<tlp-clear>}} / {{<tlp-white>}} gekennzeichnet und somit öffentlich verfügbar ist, oder ob der Zugriff darauf eingeschränkt ist.

Es empfiehlt sich, eine TLP-Klassifizierung zu definieren, auf die BOMnipotent für ein nicht gekennzeichnetes Dokument zurückgreifen kann. Sie können dies in Ihrer Konfigurationsdatei über den folgenden Eintrag tun:
```toml
[tlp]
default_tlp = "amber"
```

> Die Deserialisierung gibt Ihnen etwas Spielraum: Sie berücksichtigt die Groß-/Kleinschreibung nicht und das Präfix „TLP:“ ist optional. Die Werte „amber“, „AMBER“, „tlp:amber“ und „TLP:AMBER“ werden alle als {{<tlp-amber>}} erkannt.

Wenn Sie kein Standard-TLP-Label angeben und BOMnipotent auf ein unbeschriftetes Dokument stößt, wird standardmäßig {{<tlp-red>}} verwendet und eine Warnung ausgegeben.

Das Default-TLP Label wird **zum Zeitpunkt des Zugriffs** ausgewertet, nicht zum Zeitpunkt des Schreibens. Unklassifizierte Dokumente bleiben in der Datenbank unklassifiziert. Wenn Sie das Default-TLP Label zu irgendeinem Zeitpunkt ändern, ändern Sie es somit für alle unklassifizierten Dokumente der Vergangenheit und Zukunft.
