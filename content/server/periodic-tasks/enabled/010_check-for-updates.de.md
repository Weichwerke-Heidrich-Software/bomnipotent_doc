+++
title = "Check for Updates"
slug = "check-for-updates"
weight = 10
description = "Prüft automatisch auf neue BOMnipotent Server-Versionen, meldet Update-Möglichkeiten (INFO) und veraltete Versionen (WARN)."
+++

Diese Aufgabe sendet eine Anfrage an [www.bomnipotent.de](https://www.bomnipotent.de/downloads) um zu prüfen, ob eine neue Version von BOMnipotent Server zur Verfügung steht. Sie gibt einen Log mit INFO Level aus falls der Server aktualsiert werden kann, und einen Log mit WARN Level falls Ihre Version nicht mehr unterstützt wird.

Der Name dieser Aufgabe ist "check_for_updates". Sie akzeptiert die folgenden [Konfigurationen](/de/server/periodic-tasks/configuring-tasks/):
```toml
[[tasks]]
name = "check_for_updates"
period = "1 day" # Optional
enabled = true # Optional
```
