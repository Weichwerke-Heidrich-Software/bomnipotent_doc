+++
title = "Roboternutzer"
slug = "robot-users"
weight = 50
description = "Erfahren Sie, wie Sie in BOMnipotent Roboternutzer für sichere Automatisierung, CI/CD-Integration und rollenbasierte Rechte erstellen und verwalten."
+++

Nicht alle Konten sind notwendigerweise mit einem menschlichen Nutzer assoziiert. BOMnipotent ist gebaut, um in Pipelines integriert zu werden. Um ein Konto zu erstellen, welches in Automatisierung genutzt werden soll, fügen Sie der Anfrage die 'robot' Option hinzu:

{{< example "user_request_robot" >}}

Dies markiert das Konto als Roboter, und verschickt **keine** Verifizierungsmail. Um ein solches Konto zu genehmigen, müssen Sie die 'robot' Option nutzen:

{{< example user_approve_robot >}}

> [!NOTE]
> Da Roboternutzer nicht verifiziert werden, und üblicherweise erhöhte Rechte haben, sollten Sie absolut sicher sein, dass dies das Konto ist, welches Sie genehmigen wollen.

Um die generierten Schlüssel nicht aus dem etwas versteckten Nutzerordner heraussuchen zu müssen, können Sie bei der Generierung einen Wunsch-Ablageort angeben:

{{< example "user_request_store_custom" "1.1.0" >}}

Nun benötigt der Roboter die Berechtigungen um BOMs hochzuladen, Sicherheitslücken zu aktualisieren, und CSAF Dokumente zu lesen aber nicht zu modifizieren. Beginnend mit Version 1.4.0 gibt es hierfür die praktische Rolle "robot", welche genau diese Berechtigungen enthält:

{{< example "add_robot_role" "1.4.0" >}}

Beachten Sie, dass diese Rolle Lesezugriff auf die CSAF Dokumente *aller* Produkte enthält:

{{< example "robot_role_permissions" "1.4.0" >}}

Sie können die Berechtigungen natürlich nach Belieben anpassen.

Nun können Sie die Zugangsdaten Ihres Roboters in Ihrer [CI/CD](/de/integration/ci-cd/) Pipeline verwenden.
