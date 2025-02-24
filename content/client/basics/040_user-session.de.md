+++
title = "Benutzersitzung"
slug = "user-session"
weight = 40
+++

## Anmeldung

Der BOMnipotent Client bietet mehrere globale optionale Argumente. Um diese nicht immer wieder angeben zu müssen, können Sie den Anmeldebefehl verwenden, um sie in einer Benutzersitzung zu speichern:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --domain=<Server> --email=<Ihre-Email> --output=<Modus> --secret-key=<Pfad/zum/Schlüssel> --trusted-root=<Pfad/zum/Zertifikat> login
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -d <Server> -e <Ihre-Email> -o <Modus> -s <Pfad/zum/Schlüssel> -t <Pfad/zum/Zertifikat> login
```
{{% /tab %}}
{{< /tabs >}}

Dies erstellt eine Datei im lokalen Benutzerordner, die die angegebenen Parameter speichert.
``` {wrap="false" title="output"}
[INFO] Storing session data in /home/simon/.config/bomnipotent/session.toml
```

Wann immer Sie den BOMnipotent Client von nun an aufrufen, werden diese Parameter automatisch verwendet:

```bash
bomnipotent_client bom list # Wird automatisch die angegebene Domain kontaktieren und Ihre Authentifizierungsdaten verwenden.
```

## Parameter überschreiben

Wenn Sie angemeldet sind und bei einem Aufruf des BOMnipotent Clients globale optionale Parameter angeben, werden diese stattdessen verwendet:
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --domain=<anderer-Server> bom list # Wird den andereren Server kontaktieren
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -d <anderer-Server> bom list # Wird den andereren Server kontaktieren
```
{{% /tab %}}
{{< /tabs >}}

Um die im Sitzungsspeicher gespeicherten Daten dauerhaft zu ändern, melden Sie sich einfach erneut mit den neuen Parametern an.

Dies kann auch verwendet werden, um Parameter zu entfernen, indem Sie sie einfach nicht angeben: 
{{< tabs >}}
{{% tab title="lang" %}}
```bash
bomnipotent_client --domain=<anderer-Server> --email=<Ihre-Email> --output=<mode> login # Setzt secret-key und trusted-root zurück.
```
{{% /tab %}}
{{% tab title="kurz" %}}
```bash
bomnipotent_client -d <anderer-Server> -e <Ihre-Email> -o <Modus> login # Setzt secret-key und trusted-root zurück.
```
{{% /tab %}}
{{< /tabs >}}

## Abmeldung

Um alle Parameter zu entfernen, rufen Sie logout auf:
```bash
bomnipotent_client logout
```
Dies entfernt die Sitzungsdatei.
