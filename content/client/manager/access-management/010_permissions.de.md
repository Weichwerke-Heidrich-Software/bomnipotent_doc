+++
title = "Berechtigungen"
slug = "permissions"
weight = 10
description = "Erfahren Sie, wie Berechtigungen in BOMnipotent verwaltet werden, einschließlich Rollenverknüpfungen und spezifischer Zugriffsrechte für Konsumenten und Manager."
+++

In BOMnipotent sind Berechtigungen nicht direkt mit Benutzerkonten, sondern mit Rollen verknüpft. Der Abschnitt zur [Rollenverwaltung](/de/client/manager/access-management/role-management/) beschreibt, wie diese Verknüpfung verwaltet wird, und der Abschnitt zur [Rollenzuweisung](/de/client/manager/access-management/role-assignment/) erläutert, wie Rollen (und damit letztlich Berechtigungen) Benutzern zugewiesen werden.

Der Server verfügt über mehrere Berechtigungen im Code, von denen einige fest programmiert, andere konfigurierbar sind. Alle werden hier erläutert. Informationen zum Erstellen einer Berechtigung, die einer Rolle zugeordnet ist, finden Sie im entsprechenden [Abschnitt](/de/client/manager/access-management/role-management/).

Die Berechtigungen lassen sich gedanklich in Berechtigungen für [Konsumenten](#berechtigungen-für-konsumenten), [Manager](#berechtigungen-für-manager) und einige [Sonderberechtigungen](#sonderberechtigungen-für-administratoren) für Administratoren unterteilen.

## Berechtigungen für Konsumenten

Ihre Kunden sind in der Regel mit einem oder mehreren Ihrer Produkte verknüpft. Sie möchten alle Arten von Dokumenten und Informationen zu diesem Produkt einsehen, haben aber nicht automatisch Anspruch auf Informationen zu anderen Produkten.

### PRODUCT_ACCESS

Eine Berechtigung mit dem Wert "PRODUCT_ACCESS(\<PRODUCT\>)" gewährt Leseberechtigung für alle mit "\<PRODUCT\>" verknüpften Dokumente. Dies umfasst alle Stücklisten (BOMs) dieses Produkts, alle damit verbundenen Schwachstellen und alle CSAF-Dokumente zu diesem Produkt.

Beispielsweise könnte eine Rolle mit dem Wert "PRODUCT_ACCESS(BOMnipotent)" alle mit BOMnipotent verknüpften Dokumente (und nur diese) einsehen.

Dem Sternchen-Operator "\*" kann als Globbing-Platzhalter für Produktnamen genutzt werden. Dabei entspricht das Sternchen einer beliebigen Anzahl von Symbolen. Beispielsweise würde die Berechtigung "PRODUCT_ACCESS(BOM\*ent)" sowohl auf "BOMnipotent" als auch auf die (fiktiven) Produkte "BOMent" und "BOM-burárum-ent" zutreffen, nicht jedoch auf "BOMtastic" (da letzteres nicht auf "ent" endet).

Folglich ermöglicht "PRODUCT_ACCESS(\*)" die Anzeige aller Dokumente.

## Berechtigungen für Manager

Für Dokumentmanager ist die Situation in der Regel umgekehrt: Sie benötigen die Berechtigung, die Datenbankinhalte nicht nur anzuzeigen, sondern auch zu ändern. Ihr Umfang ist typischerweise nicht auf ein bestimmtes Produkt, sondern auf einen bestimmten Dokumenttyp beschränkt. Daher wird die Trennung der Managerberechtigungen aus einer anderen Perspektive betrachtet.

### BOM_MANAGEMENT

Diese Berechtigung ermöglicht das [Hochladen, Ändern und Löschen](/de/client/manager/doc-management/boms/) von Stücklisten (BOMs). Sie gewährt automatisch auch die Berechtigung zur Anzeige aller gehosteten Stücklisten.

### VULN_MANAGEMENT

Diese Berechtigung ermöglicht das [Aktualisieren und Anzeigen](/de/client/manager/doc-management/vulnerabilities/) der Liste der Schwachstellen, die mit einer BOM verknüpft sind.

### CSAF_MANAGEMENT

Diese Berechtigung ermöglicht das [Hochladen, Ändern und Löschen](/de/client/manager/doc-management/csaf-docs/) von CSAF-Dokumenten (Common Security Advisory Framework). Sie gewährt außerdem automatisch Anzeigeberechtigungen für alle gehosteten CSAF-Dokumente.

### ROLE_MANAGEMENT

Mit dieser Berechtigung kann ein Benutzer die [Berechtigungen von Rollen ändern](/de/client/manager/access-management/role-management/). Dies kann weitreichende Folgen haben, da die Änderungen potenziell viele Benutzer betreffen.

### USER_MANAGEMENT

Diese Berechtigung ist erforderlich, um [Benutzer anzuzeigen, oder ihre Anfragen zur Kontoerstellung zu gewähren oder abzulehnen](/de/client/manager/access-management/user-management/). Sie wird auch benötigt, um Nutzern [Rollen zuzuweisen](/de/client/manager/access-management/role-assignment/).

## Sonderberechtigungen für Administratoren

BOMnipotent kennt die feststehende Rolle "admin". Diese Rolle verfügt stets über alle Berechtigungen, die Benutzern erteilt werden können. Darüber hinaus gibt es einige Aufgaben, die nur von Benutzern mit der Administratorrolle ausgeführt werden können:
– Nur Administratoren können die Administratorrolle anderen Benutzern [zuweisen oder entziehen](/de/client/manager/access-management/role-assignment/). Ein [spezieller temporärer Administratormechanismus](/de/server/setup/admin/) ermöglicht die Erstellung des ersten Administrators für einen neu erstellten BOMnipotent Server.
– Nur Administratoren können den Abonnementschlüssel für eine BOMnipotent Server Instanz [(de)aktivieren](/de/client/manager/subscription/).
- Nur Administratoren können [Sicherungen der Datenbank](/de/client/manager/backup-management/) erstellen und wiederherstellen.
