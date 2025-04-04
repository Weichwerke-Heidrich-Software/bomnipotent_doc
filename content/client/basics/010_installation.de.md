+++
title = "Client Installation"
slug = "installation"
weight = 10
description = "Anleitung zur Installation des BOMnipotent Clients auf Windows, MacOS und Linux, inklusive automatisierter Download-Links."
+++

Um BOMnipotent Client manuell herunterzuladen, gehen Sie zu [https://www.bomnipotent.de/downloads/](https://www.bomnipotent.de/de/downloads/), wählen Sie Ihre Platform und Version, und klicken Sie auf den Download Button.

Um den Prozess weiter zu automatisieren, können Sie den Download Link direkt nutzen:
{{< tabs >}}
{{% tab title="Windows" %}}
```
Invoke-WebRequest -Uri https://www.bomnipotent.de/downloads/raw/latest/windows/bomnipotent_client.exe -OutFile bomnipotent_client.exe
```
{{% /tab %}}
{{% tab title="MacOS" %}}
```
curl -O https://www.bomnipotent.de/downloads/raw/latest/macos/bomnipotent_client
chmod +x bomnipotent_client
```
{{% /tab %}}
{{% tab title="Linux (glibc)" %}}
```
wget https://www.bomnipotent.de/downloads/raw/latest/debian-glibc/bomnipotent_client;
chmod +x bomnipotent_client
```
{{% /tab %}}
{{% tab title="Linux (statisch gelinkt)" %}}
```
wget https://www.bomnipotent.de/downloads/raw/latest/linux-musl/bomnipotent_client;
chmod +x bomnipotent_client
```
{{% /tab %}}
{{< /tabs >}}

Ersetzen sie "latest" mit einem Spezifischen Versionstag, zum Beispiel "v1.0.0", um diese statt der neuesten herunterzuladen.

Um von überall im System auf BOMnipotent Client zugreifen zu können, verschieben Sie es in einen Ordner der in ihrer PATH Umgebungsvariable enthalten ist. Dieser Schritt ist jedoch optional.
