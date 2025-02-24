+++
title = "Client Installation"
slug = "installation"
weight = 10
+++

Um BOMnipotent Client manuell herunterzuladen, gehen Sie zu [https://www.bomnipotent.de/downloads/](https://www.bomnipotent.de/downloads/), wählen Sie Ihre Platform und Version, und klicken Sie auf den Download Button.

Um den Prozess weiter zu automatisieren, können Sie den Download Link direkt nutzen:
{{< tabs >}}
{{% tab title="Windows" %}}
```powershell
Invoke-WebRequest -Uri https://www.bomnipotent.de/downloads/raw/latest/windows/bomnipotent_client.exe -OutFile bomnipotent_client.exe
```
{{% /tab %}}
{{% tab title="MacOS" %}}
```bash
curl -O https://www.bomnipotent.de/downloads/raw/latest/macos/bomnipotent_client
chmod +x bomnipotent_client
```
{{% /tab %}}
{{% tab title="Linux (glibc)" %}}
```bash
wget https://www.bomnipotent.de/downloads/raw/latest/debian-glibc/bomnipotent_client;
chmod +x bomnipotent_client
```
{{% /tab %}}
{{% tab title="Linux (statically linked)" %}}
```bash
wget https://www.bomnipotent.de/downloads/raw/latest/linux-musl/bomnipotent_client;
chmod +x bomnipotent_client
```
{{% /tab %}}
{{< /tabs >}}

Ersetzen sie "latest" mit einem Spezifischen Versionstag, zum Beispiel "v1.0.0", um diese statt der neuesten herunterzuladen.

Um von überall im System auf BOMnipotent Client zugreifen zu können, verschieben Sie es in einen Ordner der in ihrer PATH Umgebungsvariable enthalten ist. Dieser Schritt ist jedoch optional.
