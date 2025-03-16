+++
title = "Benutzerkonto Erstellen"
slug = "account-creation"
weight = 20
description = "Anleitung zur Erstellung eines neuen Benutzerkontos bei BOMnipotent, einschließlich der Nutzung von Schlüsselpaaren und der Verwaltung gespeicherter Schlüssel."
+++

Die meisten Interaktion mit BOMnipotent benötigen eine Berechtigung. Die einzige Ausnahme ist der Zugriff auf Daten, welche als {{< tlp-white >}} / {{< tlp-clear >}} klassifiziert wurden.

Berechtigungen sind an Benutzerkonten gebunden. Weitere Informationen, wie Berechtigungen vergeben werden, befinden sich im Abschnitt über [Zugriffsverwaltung](/de/client/manager/access-management).

## Erstellung eine neuen Benutzerkontos

Ein neues Benutzerkonto erstellen Sie per
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --domain=<Server> user request <Ihre-Email>
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -d <Server> user request <Ihre-Email>
```
{{% /tab %}}
{{< /tabs >}}

Wenn Sie dies zum ersten Mal rufen, wird es ein neues [Schlüsselpaar](https://en.wikipedia.org/wiki/Public-key_cryptography) mit dem [ED25519 Algorithmus](https://en.wikipedia.org/wiki/EdDSA#Ed25519) generieren. Ein Schlüsselpaar besteht aus einem öffentlichen und einem geheimen Schlüssel. Beide werden lokal in Ihrem Nutzerordner gespeichert.

``` {wrap="false" title="output"}
[INFO] Generating new key pair
[INFO] Storing secret key to "/home/simon/.config/bomnipotent/secret_key.pem" and public key to "/home/simon/.config/bomnipotent/public_key.pem"
[INFO] User request submitted. It now needs to be confirmed by a user manager.
```

> Der geheime Schlüssel wird auch häufig "privater Schlüssel" genannt. Der Autor glaubt aber, dass "geheimer Schlüssel" eine treffendere Beschreibung ist, und außerdem, vor allem im Englischen, die Chance auf Verwechslung mit dem öffentlichen Schlüssel verringert.

Der öffentliche Schlüssel kann, im Prinzip, mit jeder beliebigen Person geteilt werden. Der "user request" Befehl schickt ihn an den BOMnipotent server. Der geheime Schlüssel hingegen sollte wie ein Passwort behandelt werden!

Alle nun folgenden Aufrufe vom BOMnipotent Client werden das existierende Schlüsselpaar wiederverwenden.

Jetzt, da Ihre Anfrage gestellt ist, müssen Sie darauf warten, dass ein Nutzermanager sie bestätigt. Danach können Sie [authentifizierte Anfragen](/de/client/basics/authenticating) stellen.

> Falls Sie dieser Nutzermanager sind und herausfinden wollen, wie Sie Nutzer bestätigen können, konsultieren Sie den Abschnitt über [Zugriffsverwaltung](/de/client/manager/access-management/user-approval/).

## Gespeicherte Schlüssel nutzen

Falls Sie ein Schlüsselpaar im üblichen Nutzerordner (welcher auf Ihre Platform ankommt) gespeichert haben, wird BOMnipotent Client ihn automatisch lesen und nutzen.

Falls Sie stattdessen gerne einen existierenden Schlüssel wiederverwenden wollen, der an einem anderen Ord gespeichert ist, dann können Sie den Pfad als positionales Argument angeben:
{{< tabs >}}
{{% tab title="lang" %}}
```
bomnipotent_client --domain=<Server> user request <Ihre-Email> <Pfad/zum/Schlüssel>
```
{{% /tab %}}
{{% tab title="kurz" %}}
```
bomnipotent_client -d <Server> user request <Ihre-Email> <Pfad/zum/Schlüssel>
```
{{% /tab %}}
{{< /tabs >}}


> Damit dies funktioniert muss der Schlüssel mit dem [ED25519 Algorithmus](https://en.wikipedia.org/wiki/EdDSA#Ed25519) generiert worden und im [PEM](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) Format gespeichert sein. Falls Sie darauf bestehen, Ihre Schlüssel selber zu verwalten, oder falls Sie ein Beispiel sehen möchten, dann können Sie ein solches Paar am einfachsten wie folgt generieren: Rufen Sie `openssl genpkey -algorithm ED25519 -out secret_key.pem` um einen geheimen Schlüssel zu generieren, und dann `openssl pkey -in secret_key.pem -pubout -out public_key.pem` um den zugehörigen öffentlichen Schlüssel zu erstellen.

Falls Sie hier aus Versehen den Pfad zu ihrem *geheimen* Schlüssel angeben wirft BOMnipotent Client eine Fehlermeldung anstatt ihn zum Server zu schicken.
