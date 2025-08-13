+++
title = "Nutzerverwaltung"
slug = "user-management"
weight = 30
description = "Erfahren Sie, wie Sie Benutzerkonten in BOMnipotent verwalten: Benutzer auflisten, genehmigen, ablehnen und löschen. Schritt-für-Schritt-Anleitungen inklusive."
+++

Der erste Schritt beim Anlegen eines neuen Benutzers ist die Beantragung eines neuen Kontos. Dieser Schritt wird [an anderer Stelle](/de/client/basics/account-creation/) beschrieben, da er sowohl für Manager als auch für Konsumenten relevant ist.

Aus Sicht von BOMnipotent ist ein Benutzer verknüpft mit einer eindeutigen E-Mail-Adresse als Kennung, und einem öffentlichen Schlüssel zur Authentifizierung. Dies sind alle Daten, die bei der Erstellung eines neuen Benutzerkontos gesendet werden.

Nach der Beantragung eines neuen Kontos obliegt es einem Benutzermanager, die Anfrage zu genehmigen oder abzulehnen.

> Für die meisten Benutzerinteraktionen, einschließlich der Auflistung, benötigen Sie die Berechtigung {{<user-management-de>}}.

## Auflisten

Um alle Benutzer in Ihrer Datenbank aufzulisten, rufen Sie

{{< example user_list >}}

So können Sie die E-Mail-Adressen und die Stati der Benutzer einsehen.

> Ein Benutzer ohne den Status "APPROVED" hat keine besonderen Berechtigungen, unabhängig von zugewiesenen Rollen.

Jedem Benutzer ist außerdem ein Ablaufdatum zugeordnet. Ab diesem Zeitpunkt wird der öffentliche Schlüssel ungültig und muss erneuert werden. Die Gültigkeitsdauer eines Schlüssels kann in der Serverkonfiguration [frei konfiguriert](/de/server/configuration/optional/user-expiration-period/) werden.

Die Liste der Nutzer kann nach Nutzername oder Genehmigungsstatus gefiltert werden, oder danach, ob das Nutzerkonto abgelaufen ist:

{{< example user_filtered_list >}}

Das "true" Argument für den "expired" Filter ist optional:

{{< example user_list_expired >}}

## Genehmigen oder Ablehnen

Wenn Sie die Benutzeranfrage erwartet haben, können Sie sie genehmigen:

{{< example user_approve >}}

Falls der Nutzer noch nicht bestätigt hat, Zugriff auf die Email Adresse zu haben, dann lehnt der Server die Genehmigung ab. Falls Sie absolut sicher sind, dass Sie wissen was Sie tun, können Sie dieses Verhalten mit der 'allow-unverified' Option überschreiben (es gibt keine Kurzformen für Befehle die Sicherheitsmaßnahmen überschreiben):

{{< example user_approve_unverified >}}

Analog dazu können Sie diesem Benutzer stattdessen keinen Zugriff gewähren:

{{< example user_deny >}}

Im Gegensatz zum Genehmigen ist es dieser Aktion egal, welchen Status das Konto vor der Ablehnung hatte.

> Es ist möglich, einem bereits genehmigten Benutzer den Zugriff wieder zu verweigern, wodurch das Konto effektiv widerrufen wird.

Ein Nutzer, dessen vorherige Anfrage für einen Nutzeraccount abgelehnt wurde, kann keine weiteren Nutzeraccounts anfragen.

## Entfernen

Wenn Sie ein Benutzerkonto vollständig löschen möchten, rufen Sie

{{< example user_remove >}}

Dies löscht zusätzlich alle dem Benutzer zugewiesenen Rollen.

## Existenz

{{< exist-subcommand-de >}}

{{< example user_exist >}}
