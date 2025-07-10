+++
title = "DoS-Prävention"
slug = "dos-prevention"
weight = 50
description = "Erfahren Sie, wie Sie Ihren BOMnipotent Server Schutz vor DoS-Angriffen feinjustieren können."
+++

Denial of Service (DoS)-Angriffe haben das Ziel, ein Programm oder einen Server unresponsiv zu machen. Sie sind bekanntermaßen schwer abzuwenden, da sie häufig darauf basieren, den Dienst mit ansonsten legitimen Anfragen zu überfluten.

BOMnipotent verfügt über mehrere DoS-Präventionsmechanismen (von der Ablehnung von Code, der den Server zum Absturz bringen könnten, bis zur Begrenzung der Länge von Protokollausgaben). Manche Techniken können vom Benutzer angepasst werden.

## Nutzerspezifische DoS Prävention

Wenn die Anzahl der Anfragen von einer einzelnen Quelle innerhalb eines Zeitraums einen Grenzwert überschreitet, wird diese Quelle für eine Stunde auf eine Greylist gesetzt, welche die Anfragen dann automatisch ablehnt.

Standardmäßig geschieht dies, wenn die Anzahl der Anfragen innerhalb einer Minute 100 überschreitet, aber Sie können dieses Verhalten in Ihrer Konfigurationsdatei ändern:
```toml
[dos_prevention]
limit = 50 # Standard ist 100
period = "30 Sekunden" # Standard ist "1 Minute"
```

Diese neue Konfiguration würde den Server schneller auf einen möglichen DoS-Angriff reagieren lassen, birgt aber auch ein erhöhtes Risiko, Anfragen fälschlicherweise als Angriff zu werten.

## Globale Request User DoS Prävention

Die HTTP-Anfrage zum Anlegen eines neuen Benutzers ist typischerweise keinem bestehenden Benutzer zugeordnet. Die benutzerspezifische DoS-Prävention verwendet zwar weiterhin die IP-Adresse der Anfrage, schützt aber nicht vor IP-Spoofing oder verteilten (D)DoS-Angriffen. Weiterhin bietet es Angreifern die Möglichkeit, die Datenbank durch Hinzufügen von Schlüsseln zu verändern.

Zum Glück ist die Anfrage nach einem neuen Benutzer etwas, was eher selten erwartet wird. Aus diesem Grund gibt es ein globales Limit für Benutzeranfragen. Die Standardwerte sind deutlich strenger, können aber ebenfalls angepasst werden:
```toml
[user.new_user_dos_prevention]
limit = 10 # Standard ist 3
period = "20 seconds" # Standard ist "10 seconds"
```

Da die Anfrage nicht zuverlässig mit einer Quelle assoziiert werden kann betreibt diese Prävention kein Greylisting.
