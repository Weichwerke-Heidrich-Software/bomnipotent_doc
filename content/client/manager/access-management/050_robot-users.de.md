+++
title = "Roboternutzer"
slug = "robot-users"
weight = 50
+++

Nicht alle Konten sind notwendigerweise mit einem menschlichen Nutzer assoziiert. BOMnipotent ist gebaut, um in Pipelines integriert zu werden. Um ein Konto zu erstellen, welches in Automatisierung genutzt werden soll, fügen Sie der Anfrage die 'robot' Option hinzu:

{{< example "user_request_robot" >}}

Dies markiert das Konto als Roboter, und verschickt **keine** Verifizierungsmail. Um ein solches Konto zu genehmigen, müssen Sie die 'robot' Option nutzen:

{{< example user_approve_robot >}}

> [!NOTE]
> Da Roboternutzer nicht verifiziert werden, und üblicherweise erhöhte Rechte haben, sollten Sie absolut sicher sein, dass dies das Konto ist, welches Sie genehmigen wollen.

Ein plausibles Setup ist, dem Roboternutzer Rollen mit den Berechtigungen {{<bom-management-de>}} und {{<vuln-management-de>}} zu geben, sodass er BOMs hochladen und Sicherheitslücken aktualisieren kann:

{{< example user_role_add_robot >}}

Nun können Sie die Zugangsdaten Ihres Roboters in Ihrer [CI/CD](/de/integration/ci-cd/) Pipeline verwenden.
