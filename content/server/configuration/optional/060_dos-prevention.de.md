+++
title = "DOS-Prävention"
slug = "dos-prevention"
weight = 60
description = "Erfahren Sie, wie Sie Ihren BOMnipotent Server Schutz vor DOS-Angriffen feinjustieren können."
+++

Denial of Service (DOS)-Angriffe haben das Ziel, ein Programm oder einen Server unresponsiv zu machen. Sie sind bekanntermaßen schwer abzuwenden, da sie häufig darauf basieren, den Dienst mit ansonsten legitimen Anfragen zu überfluten.

BOMnipotent verfügt über mehrere DOS-Präventionsmechanismen (von der Ablehnung von Code, der den Server zum Absturz bringen könnten, bis zur Begrenzung der Länge von Protokollausgaben), aber eine bestimmte Technik kann vom Benutzer angepasst werden.

Wenn die Anzahl der Anfragen von einer einzelnen Quelle innerhalb eines Zeitraums einen Grenzwert überschreitet, wird diese Quelle für eine Stunde auf eine Greylist gesetzt, welche die Anfragen dann automatisch ablehnt.

Standardmäßig geschieht dies, wenn die Anzahl der Anfragen innerhalb einer Minute 100 überschreitet, aber Sie können dieses Verhalten in Ihrer Konfigurationsdatei ändern:
```toml
[dos_prevention]
limit = 50 # Standard ist 100
period = "30 Sekunden" # Standard ist "1 Minute"
```

Diese neue Konfiguration würde den Server schneller auf einen möglichen DOS-Angriff reagieren lassen, birgt aber auch ein erhöhtes Risiko, Anfragen fälschlicherweise als Angriff zu werten.
