+++
title = "Temporäre Adminrechte"
slug = "tmp-admin"
weight = 20
description = "Erfahren Sie, wie Sie temporäre Adminrechte mit dem Konfigurationsparameter tmp_admin sicher einrichten und verwalten können."
+++

Nur ein Administrator kann einem Benutzer Administratorrechte erteilen. Um den ersten Administrator zu erstellen, müssen Sie diese Rechte daher über einen anderen, temporären Pfad aktivieren. Dies geschieht mit dem Konfigurationsparameter "tmp_admin", der die E-Mail-Adresse eines Benutzers als Eingabe verwendet:

```toml
[user]
tmp_admin = "<email>"
```

Das gesamte Verfahren ist in der[Anleitung zum Aufsetzen des Servers](/de/server/setup/admin) beschrieben.

Aus Sicherheitsgründen sind die Regeln für die temporäre Administratorrolle recht streng und erlauben nur eine bestimmte Reihenfolge der Vorgänge:
1. Fordern Sie einen neuen Benutzer an. Der Parameter "tmp_admin" darf an dieser Stelle noch nicht in der Konfigurationsdatei stehen, da die Anforderung sonst vom Server abgelehnt wird. Eine Anforderung für einen neuen Benutzer mit derselben E-Mail-Adresse wird ebenfalls abgelehnt.
1. Markieren Sie diesen Benutzer in der Konfiguration als temporären Administrator. Wenn der Benutzer nicht existiert, kann die Konfiguration nicht geladen werden.
1. Machen Sie den Benutzer zu einem richtigen Administrator, indem Sie ihn genehmigen und die Administratorrolle hinzufügen.
1. Entfernen Sie den Parameter "tmp_admin" aus der Serverkonfiguration. Die Serverprotokolle geben Warnmeldungen aus, solange er noch aktiv ist.

> Wenn die Regeln weniger streng wären und Sie einen temporären Administrator festlegen könnten, bevor der Benutzer in der Datenbank registriert wird, könnte ein Angreifer möglicherweise einen neuen Benutzer mit der richtigen E-Mail-Adresse anfordern und hätte dann Administratorrechte auf Ihrem System.
