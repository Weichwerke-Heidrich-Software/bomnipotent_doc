+++
title = "Workflow Integration"
weight = 40
description = "Guide for integrating BOMnipotent into workflows, including SBOM creation, vulnerability scanning, and CSAF document generation with tools like Syft, Grype, and Secvisogram."
+++

Sobald der BOMnipotent-Server läuft, können Sie mit dem Hochladen von Dokumenten beginnen. Ein typischer Workflow beginnt mit der Erstellung eines SBOM, einer Inventarliste der Komponenten, die Ihr Produkt enthält. Dieser Schritt sollte automatisch ausgelöst werden, sobald eine neue Version erstellt wird. Anschließend wird dieses Inventar auf bekannte Sicherheitslücken überprüft. Auch dieser Schritt sollte automatisch erfolgen, jedoch in regelmäßigen Abständen.

Falls eine Sicherheitslücke entdeckt wird, muss sie analysiert werden. Diese Aufgabe erfordert Fachwissen und kann daher nicht automatisiert werden. Das Ergebnis dieser Analyse ist ein CSAF-Dokument, das Ihren Nutzern mitteilt, ob und wie sie auf diese neue Entwicklung reagieren müssen.

Dieser Abschnitt enthält Anleitungen für einen beispielhaften Workflow zur [Erstellung einer SBOM mit Syft](/de/integration/syft/), [Überprüfung auf Sicherheitslücken mit Grype](/de/integration/grype/), und [Erstellung von CSAF Dokumenten mit Secvisogram](/de/integration/secvisogram/). Es gibt auch andere Programme für diese Aufgaben. Solange sie gültige CycloneDX- und CSAF-JSON-Dokumente erzeugen, sind sie mit BOMnipotent kompatibel.
