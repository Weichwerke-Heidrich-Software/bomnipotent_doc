+++
title = "Installing the Client"
slug = "installation"
weight = 10
+++

To manually download BOMnipotent Client, go to [https://www.bomnipotent.de/downloads/](https://www.bomnipotent.de/downloads/), select your platform and version, and click on the download button.

To automate this process further, you can access the download link directly:
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

Replace "latest" with a specific version tag, e.g. "v1.0.0", to download a specific version.

To access BOMnipotent Client from anywhere in your system, move it into a folder that is included in your PATH. This step is optional, though.
