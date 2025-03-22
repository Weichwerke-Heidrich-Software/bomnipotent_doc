+++
title = "Zugriffsverwaltung"
weight = 30
+++

Dokumente zur Lieferkettensicherheit sind das Was von BOMnipotent, Nutzer das Wer. Sofern Sie nicht ausdrücklich etwas anderes angeben, sind die gehosteten Dokumente nur für die Nutzerkonten sichtbar, welch von Ihnen Zugriff erahalten haben.

BOMnipotent verwendet rollenbasierte Zugriffskontrolle (RBAC): Nutzer haben Rollen, und Rollen haben [Berechtigungen](/de/client/manager/access-management/permissions/). Nach der Einrichtung enthält BOMnipotent einige Standardrollen. Diese reichen für die Serververwaltung aus. Um jedoch Nutzeranfragen annehmen zu können, sollten Sie mindestens eine neue Rolle [erstellen](/de/client/manager/access-management/role-management/).

Sobald dies erledigt ist, sieht ein typischer Workflow zur Einführung eines neuen Nutzers in Ihr BOMnipotent-System wie folgt aus:
1. Ein neuer Nutzer [erfragt Zugriff](/de/client/basics/account-creation/) zu Ihrem Server. Dabei sendet der BOMnipotent-Client einen mit dem Konto verknüpften öffentlichen Schlüssel an Ihren Server, wo er gespeichert und als "REQUESTED" gekennzeichnet wird.
1. Sie [genehmigen](/de/client/manager/access-management/user-management/) die Anfrage. Das neue Benutzerkonto wird nun als gültig akzeptiert, verfügt aber noch über keine Berechtigungen.
1. Sie [weisen](/de/client/manager/access-management/role-assignment/) dem neuen Benutzerkonto eine oder mehrere Rollen zu.