+++
title = "Aufgaben konfigurieren"
slug = "configuring-tasks"
weight = 10
+++

Angefangen mit Version 1.4.0 von BOMnipotent Server können die Parameter von zyklischen Aufgaben in der [Config.toml](/server/configuration/config-file/) Datei konfiguriert werden. Diese werden in den "[[tasks]]" Abschnitten spezifiziert:

```toml
# ... anderer Inhalt
[[tasks]]
name = "<name>"
period = "<period>"
enabled = true # Optional, true ist der Standard.
# Möglicherweise mehr Parameter

[[tasks]]
name = "<other name>"
```

> [!INFO]
> Die doppelten Klammern um "tasks" markieren den Abschnitt als Eintrag in einer Liste. Deswegen darf es mehrfach vorkommen.

Der einzige Parameter, der immer benötigt wird, ist "name". Er muss einen Namen enthalten, den BOMnipotent kennt. Die Namen aller bekannten Aufgaben sind in dieser Dokumentation aufgelistet. Diese Liste kann von Version zu Version wachsen.

Der "period" Parameter kontrolliert, wie viel Zeit zwischen zwei Ausführungen einer Aufgabe vergeht.

> Streng genommen spezifiert er nur die minimale Zeit zwischen zwei Ausführungen, da alle zyklischen Aufgaben im selben Thread ausgeführt werden und sich somit gegenseitig blockieren können.

Die Zeitspanne kann im (englischen) menschenlesbaren Format spezifiziert werden, beispielsweise "2 days" oder "3h". Falls er nicht angegeben wird, fällt er auf den Wert "1 day" zurück und die Aufgabe wird etwa alle 24 Stunden ausgeführt.

> BOMnipotent hält Sie nicht davon ab, eine albern kurze Zeitspanne wie "1 ms" festzulegen. Allerdings sind die Aufgaben mit Zeitspannen von Stunden entwickelt worden, nicht Millisekunden. Es wird nicht garantiert, dass Aufgaben genau dann ausgeführt werden, wenn sie fällig sind. Zeitspannen unterhalb einer Stunden verbrauchen vermutlich nur unnötig Energie und fluten die Logs.

Manche zyklischen Aufgaben sind standardmäßig [eingeschaltet](/de/server/periodic-tasks/enabled/), andere [nicht](/server/periodic-tasks/disabled/). Ob sie in den Zeiplan eingereiht werden kann über den "enabled" Parameter ausgesteuert werden. Falls irgendwelche Parameter für eine Aufgabe angegeben werden, wird für "enabled" der Wert "true" angenommen: Alleine schon den "name" Parameter anzugeben reicht aus, um eine standardmäßig ausgeschaltete Aufgabe einzuschalten. Auf der anderen Seite muss "enabled" explizit auf "false" gesetzt werden, um eine standardmäßig eingeschaltete Aufgabe von der Ausführung abzuhalten.

[Standardmäßig eingeschaltete](/de/server/periodic-tasks/enabled/) Aufgaben laufen mit Standard-Parametern. Falls Sie explizite Parameter im Config.toml angeben werden die Standard-Paramter damit überschrieben.

Nach einem Start oder Neustart des Servers werden alle zyklischen Aufgaben ausgeführt, sobald die Datenbank bereit ist.

Zyklische Aufgaben unterstützen das Hot Reloading der Konfiguration. Wenn Sie die Config.toml Datei anpassen während der Server läuft, werden die Aufgaben entsprechend der neuen Parameter umgeplant. Falls eine vorher ausgeschaltete Aufgabe eingeschaltet wird, wird sie direkt ausgeführt, nachdem die Konfiguration geladen ist. Dies gilt auch, falls die Zeitspanne einer Aufgabe so gekürzt wird, dass ihr nächster Ausführungszeitpunkt in der Vergangenheit liegt.
