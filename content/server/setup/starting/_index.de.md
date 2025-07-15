+++
title = "Starten des Servers"
weight = 10
description = "Erfahren Sie, wie Sie Ihren BOMnipotent-Server mit verschiedenen Methoden wie Docker Compose oder als freistehende Anwendung aufsetzen."
+++

Hier werden mehrere Einrichtungsvarianten vorgestellt. Sie können diejenige auswählen, die Ihren Anforderungen am besten entspricht, und sie nach Belieben ändern.
- Das [Setup mit Docker Compose](/de/server/setup/starting/docker-compose/) ist vermutlich das einfachste, und macht Ihren Server direkt über das Internet verfügbar. Wählen Sie diese Methode, falls Sie ein dediziertes System mit eigener IP nur für BOMnipotent Server haben.
- Das [Setup mit Proxy](/de/server/setup/starting/docker-compose-with-proxy/) ist sehr ähnlich, setzt aber zusätzlich einen Reverse-Proxy auf. Wählen Sie diese Methode, falls sie potenziell mehr als einen Service von demselben System mit der derselben IP anbieten wollen.
- Das [freistehende Setup](/de/server/setup/starting/standalone/) vermeidet den Overhead der Kontainerisierung, auf Kosten der, nun ja, Kontainerisierung. Wählen Sie diese Methode, falls Sie erfahren in klassischeren Server Setups sind.

Nachdem Sie die Schritte einer der Varianten befolgt haben, hat Ihr Server eine Standardkonfiguration und sollte über das Internet erreichbar sein. Danach sollten Sie [einen Admin User Account hinzufügen](/de/server/setup/admin/).
