+++
title = "OpenPGP Keys mit Sequoia"
slug = "open-pgp"
weight = 60
description = "Erfahren Sie, wie Sie mit Sequoia-PGP OpenPGP-Schlüssel generieren, exportieren und verwalten. Dabei werden praktische Beispiele und wichtige Konzepte der Kryptografie erläutert."
+++

Dieser Artikel behandelt, was der OpenPGP Standard ist, und was er nicht ist. Danach bietet er ein paar Beispiele wie er genutzt werden kann.

Falls Sie nur für den praktischen Teil hier sind, springen Sie gern [dorthin](#openpgp-nutzen) vor.

> Falls Sie Ihr OpenPGP Schlüsselpaar Ihrer Instanz von BOMnipotent Server zur Verfügung stellen wollen, lesen Sie den [Abschnitt](/de/server/configuration/optional/open-pgp/) über die entsprechende Konfiguration.

## Was ist OpenPGP (nicht)?

Open Pretty Good Privacy (OpenPGP) ist ein offener Standard für mehrere Dateiformate im Kontext der Kryptografie. Seine bekannteste Anwendung ist die für Ende-zu-Ende Verschlüsselung von Emails, aber er kann auch genutzt werden, um beliebige Daten, auch andere OpenPGP Dateien, kryptografisch zu signieren.

> Für den Fall, dass das Konzept von Signaturen Ihnen neu ist, befindet sich [weiter unten](#signaturen) ein oberflächliche Beschreibung.

Die erste Version des Standards stammt aus dem Jahre [1998](https://www.rfc-editor.org/rfc/rfc2440), die aktuellste (zum Zeitpunkt des Schreibens) [Version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) von 2024. Ein weiterer Meilenstein, welcher in diesem Artikel noch relevant werden wird, ist [Version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) von 2007.

Während seiner Lebenszeit wurde OpenPGP von vielen Personen und Produkten adaptiert, vor allem in der Cybersecurity Community, denn es ist ganz schön gut. Ebenfalls während und vor diesem Zeitraum wurden viele nah verwandte und nicht ganz optimal benannte Konzepte und Produkte entwickelt, was ganz schön verwirrend sein kann.

Um eine Idee davon zu bekommen, was OpenPGP ist, ist es vielleicht am besten, es mit dem zu vergleichen, was es nicht ist.

### OpenPGP vs. RSA

[RSA](https://en.wikipedia.org/wiki/RSA_cryptosystem) ist ein *mathematischer Algorithmus* für asymetrische Verschlüsselung. Es spezifiziert, wie ein öffentlicher und geheimer Schlüssel auszusehen haben, und wie sie genutzt werden können, um Daten zu verschlüsseln, zu entschlüsseln, zu signieren und zu verifizieren.

> Es gibt mehrere solcher Algorithmen, aber RSA war für lange Zeit der am meisten genutzte, und ist es vermutlich noch immer.

OpenPGP auf der anderen Seite ist eine *Abstraktion*. Es ist möglichst Algorithmus-agnostisch designt, was bedeutet dass Sie die meiste Zeit gar nicht wissen müssen, welcher Algorithmus während einer Operation genutzt wird. Der [Standard von 2024](https://www.rfc-editor.org/rfc/rfc9580) enthält noch keine Unterstützung für Post-Quanten Verschlüsselungsalgorithmen, aber das deutsche [Bundesamt für Sicherheit in der Informationstechnik](https://www.bsi.bund.de/DE/home_node.html) (BSI) hat vor, dies mit einer [zukünftigen Version](https://datatracker.ietf.org/doc/draft-ietf-openpgp-pqc/) zu ändern.

### OpenPGP vs. PGP

OpenPGP ist ein *Standard*, also eine Reihe formaler Regeln, die ein Programm befolgen muss, um mit anderen Programmen desselben Standards kompatibel zu sein.

PGP ist *ein solches Programm*, welches den OpenPGP-Standard implementiert. Es ist sogar das erste Programm, welches den Standard implementiert, da es 1991 veröffentlicht wurde und damit sieben Jahre älter als OpenPGP ist. Der offene Standard wurde *von* PGP abgeleitet und nicht umgekehrt.

Als kommerzielles Programm hat PGP mehrmals den Eigentümer gewechselt und wird derzeit von [Broadcom](https://www.broadcom.com/products/cybersecurity/information-protection/encryption) weiterentwickelt.

### OpenPGP vs. GPG

[GNU Privacy Guard](https://gnupg.org/) (GPG) ist *ein weiteres Programm*, welches den OpenPGP-*Standard* implementiert. Im Gegensatz zum kommerziellen PGP-Programm wird es unter einer freien [GNU General Public License](https://de.wikipedia.org/wiki/GNU_General_Public_License) vertrieben. Die Entwickler [haben diskutiert](https://lists.gnupg.org/pipermail/gnupg-devel/1998-February/014190.html?utm_source=chatgpt.com), ob der Name zu sehr an PGP erinnert, und sind zu dem Schluss gekommen, dass dies nicht der Fall sei. Da GPG eine freie Software ist, steht Ihnen frei anderer Meinung sein.

Genauer gesagt ist GPG ein Programm, welches *LibrePGP* und OpenPGP [Version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) implementiert, aber *nicht* die aktuellere [Version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580).

### OpenPGP vs. LibrePGP

Im Jahr 2023, als [Version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) des OpenPGP-Standards [Version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) aus dem Jahr 2007 ersetzen sollte, haben mehrere Personen die vorgeschlagenen Änderungen als zu disruptiv empfunden. Insbesondere die Entwickler von [GPG](https://gnupg.org/) und [RNP](https://www.rnpgp.org/) (einer Erweiterung für Thunderbird) haben sich [entschieden](https://lwn.net/Articles/953797/), den aktuelleren Standard *nicht* zu übernehmen und stattdessen den *neuen, konkurrierenden Standard* [LibrePGP](https://librepgp.org/) basierend auf OpenPGP Version 4 zu entwickeln.

Version 4 / RFC 4880 wurde nicht ohne Grund von Version 6 / RFC 9580 abgelöst, und das BSI (welches GPG finanziell unterstützt) empfiehlt in Teil 3 seiner [technischen Richtlinie](https://www.bsi.bund.de/DE/Themen/Unternehmen-und-Organisationen/Standards-und-Zertifizierung/Technische-Richtlinien/TR-nach-Thema-sortiert/tr03183/TR-03183_node.html) zum Cyber Resilience Act, Version 6 / RFC 9580 zu verwenden. Deswegen empfiehlt auch diese Anleitung, Version 6 zu verwenden, obgleich das vielgenutzte GPG und seine Windows Variante [Gpg4win](https://gpg4win.de/index-de.html) diese zum Zeitpunkt des Schreibens (September 2025) nicht unterstützen.

### OpenPGP vs. S/MIME

[Secure Multipurpose Internet Mail Extensions](https://de.wikipedia.org/wiki/S/MIME) (S/MIME) ist wie OpenPGP ein *Standard*, der primär auf die Ende-zu-Ende-Verschlüsselung von E-Mails abzielt. Die beiden Standards verfügen über ähnliche Funktionen, sind aber *nicht* interoperabel.

Der wichtigste konzeptionelle Unterschied zwischen S/MIME und OpenPGP liegt in der Beantwortung der Frage: „Kann ich diesem öffentlichen Schlüssel vertrauen?“

S/MIME basiert auf [X.509-Zertifikaten](https://de.wikipedia.org/wiki/X.509), die eine „Vertrauenskette“ bilden. Den Anfang dieser Kette bildet eine *zentrale* Zertifizierungsstelle, die mit einem auf Ihrem Computer gespeicherten öffentlichen Schlüssel verknüpft ist. Diese Zertifizierungsstelle signiert andere Zertifikate (in der Regel gegen Bezahlung und Vorlage eines Ausweises) und signalisiert Ihrem Computer damit, dass er ihnen vertraut. Da Ihr Computer der Zertifizierungsstelle vertraut, vertraut er auch diesen signierten Zertifikaten.

OpenPGP hingegen nutzt ein „Vertrauensnetz“. Jeder kann die Authentizität anderer bestätigen. Wenn genügend Personen, denen Ihr Computer vertraut, ein bestimmtes Zertifikat signiert haben, kann Ihr Computer entscheiden, diesem Zertifikat ebenfalls zu vertrauen.

> Im Kontext der E-Mail-Verschlüsselung ist S/MIME eine absolut valide Alternative zu OpenPGP, insbesondere für Unternehmen. BOMnipotent benötigt jedoch OpenPGP-Schlüssel.

## OpenPGP nutzen

Zur Verwaltung von OpenPGP-Schlüsseln empfiehlt diese Anleitung die Verwendung des Kommandozeilentools [Sequoia-PGP](https://sequoia-pgp.org/). Es handelt sich um eine kommerziell unterstützte Open-Source-Implementierung des OpenPGP-Standards. Das bedeutet, dass die Pflege des Projekts finanziell motiviert ist und der Code gleichzeitig von Sicherheitsforschenden eingesehen werden kann. Das Programm ist zudem sehr gut [dokumentiert](https://book.sequoia-pgp.org/).

> [!NOTE] Warum nicht GPG?
> Die Entwickler der bekannteren Programme [GnuPG](https://gnupg.org) und seiner Windows-Variante [Gpg4Win](https://www.gpg4win.org/index-de.html) haben sich gegen die Implementierung des [neuesten und empfohlenen](https://www.rfc-editor.org/rfc/rfc9580) OpenPGP-Standards entschieden. Stattdessen haben sie ihren eigenen Standard [LibrePGP](https://librepgp.org/) entwickelt, der auf OpenPGP [Version 4 / RFC 4880](https://www.rfc-editor.org/rfc/rfc4880) basiert.

> [!INFO]
> Zum Ver- und Entschlüsseln von E-Mails benötigen Sie ein für Ihr E-Mail-Programm geeignetes Plugin. Dies ist zwar die Hauptanwendung von OpenPGP-Schlüsseln, steht aber nicht im Mittelpunkt dieser Anleitung.

### Installieren

#### Aus einem Repository

Die Sequoia-PGP-Dokumentation bietet verschiedene Möglichkeiten zur [Installation](https://book.sequoia-pgp.org/installation.html) des Programms auf verschiedenen Plattformen. Windows wird jedoch nicht direkt unterstützt. Stattdessen wird die Verwendung des Windows-Subsystems für Linux (WSL) empfohlen, das sich erfreulicherweise einfach [aufsetzen](https://learn.microsoft.com/de-de/windows/wsl/install) lässt.

Diese Anleitung basiert auf Sequoia-PGP Version 1.3.1, die mit Debian 13 "Trixie" ausgeliefert wird. Wenn Sie sich nicht sicher sind, welche Version Ihr Repository enthält, führen Sie Folgendes aus:

{{< example apt_cache_policy_sq >}}

Falls die Version größer als 1.0.0 ist können Sie guten Gewissens aus dieser Quelle installieren:

{{< example install_sq_apt >}}

#### Aus dem Quellcode (Debian 12 und früher)

Regelmäßige Debian-Nutzer werden nicht überrascht sein, dass die Programmversion im Repository mehrere Jahre zurückliegen kann. Debian 12 kommt mit SequoiaPGP v0.27.0. Falls Ihre Repository Version so weit zurückliegt, wird empfohlen, stattdessen die Schritte zum [Bauen des Programms](https://book.sequoia-pgp.org/installation.html#install-from-source) aus den Quellen zu befolgen (oder auf ein neueres Betriebssystem zu aktualisieren). Dies erfordert die Rust-Toolchain. Glücklicherweise ist die Installation auch [erfreulich unkompliziert](https://www.rust-lang.org/tools/install).

> Windows-Nutzer, denken Sie daran die **Linux**-Installation **innerhalb** des WSL auszuführen.

Anschließend müssen Sie einige Systembibliotheken wie in der Anleitung [beschrieben](https://book.sequoia-pgp.org/installation.html#install-the-dependencies-debian-12-bookworm--ubuntu-2404) installieren, da Sequoia-PGP nicht in reinem Rust geschrieben ist (weshalb es nicht mit Windows kompatibel ist):

{{< example install_sq_deps >}}

Führen Sie abschließend den Befehl aus:

{{< example install_sq >}}

Dadurch wird Sequoia-PGP gebaut und der Befehl "sq" in Ihrem Terminal verfügbar.

### Schlüssel generieren

> [!INFO] Schlüsselbegriffe
> Im Bereich der asymmetrischen Kryptografie verwenden BOMnipotent und diese Dokumentation den Begriff "public key" ("öffentlicher Schlüssel") für den Schlüssel, den Sie frei mit der Welt teilen können, und den Begriff "secret key" ("geheimer Schlüssel") für den Schlüssel, auf den nur Sie Zugriff haben sollten. Sequoia-PGP und dessen Dokumentation verwenden hingegen den Begriff "certificate" ("Zertifikat") für öffentliche Schlüssel und einfach den Begriff "key" ("Schlüssel") für geheime Schlüssel.

Nach der Installation von Sequoia-PGP können Sie mit folgendem Befehl einen neuen Schlüssel generieren:

{{< example sq_generate >}}

Der Befehl fordert Sie zur Eingabe eines Passworts auf. Wenn Sie dieses leer lassen, ist die Datei unverschlüsselt.

Dadurch wird die Datei direkt Ihrem Schlüsselspeicher hinzugefügt, sodass Sequoia-PGP sie kennt. Der Schlüsselspeicher ist spezifisch für Sequoia-PGP, und unterscheidet sich leicht vom (betriebssystemweiten) Schlüsselbund.

Der Parameter "shared-key" teilt dem Programm mit, dass Sie diesem Schlüssel nicht die höchste Vertrauensstufe einräumen. Der andere mögliche Parameter ist "own-key", was bedeutet, dass Sie ihm voll vertrauen. Einer der beiden muss im Befehl enthalten sein.

Die Parameter "name" und "email" dienen der Identifizierung des Schlüsselinhabers. Dies zeigt nicht nur anderen, wem dieser Schlüssel gehört, sondern erleichtert Ihnen auch die Interaktion mit Ihren Schlüsseln.

Die Option "profile" mit dem Wert "rfc9580" weist Sequoia-PGP an, die empfohlene [Version 6 / RFC 9580](https://www.rfc-editor.org/rfc/rfc9580) des OpenPGP-Standards zu verwenden.

Weitere Optionen finden Sie in der [Dokumentation](https://book.sequoia-pgp.org/sq_key_generation.html) oder durch Aufruf von:

{{< example sq_generate_help >}}

Sie können alle Ihre Schlüssel mit folgendem Befehl auflisten:

{{< example sq_key_list >}}

### Schlüssel exportieren

#### Öffentliche Schlüssel

Um einen öffentlichen Schlüssel (ein "Zertifikat") aus Ihrem Schlüsselspeicher zu exportieren, rufen Sie Folgendes auf:

{{< example sq_cert_export >}}

Dieser Befehl nutzt die Tatsache, dass Sie beim [Generieren](#schlüssel-generieren) des Schlüssels eine E-Mail-Adresse angegeben haben. Andernfalls müssten Sie den Footprint herausfinden und verwenden, um den zu exportierenden öffentlichen Schlüssel zu identifizieren.

Ohne die Option "output" wird der Schlüssel einfach in der Standard-Ausgabe wiedergegeben.

Sie können diese Datei nun beispielsweise im Stammverzeichnis Ihres Servers hosten und im Bereich "encryption" Ihrer [security.txt](https://securitytxt.org/) darauf verweisen.

#### Geheime Schlüssel

Damit BOMnipotent Dokumente für Sie signieren kann, müssen Sie außerdem Ihren geheimen Schlüssel exportieren:

{{< example sq_key_export >}}

Diese Datei kann natürlich **nicht** frei weitergegeben werden, sondern sollte wie ein Passwort behandelt werden.

### Signaturen

#### Grundlegendes Prinzip

Eine Signatur ist ein Objekt (man denke an eine Zeichenfolge, einige Bytes oder eine große Zahl), welches bestätigt, dass bestimmte Daten (eine E-Mail, eine Textdatei, ein Programm) von jemandem (dem Unterzeichner) im aktuellen Zustand freigegeben wurden. Wenn Sie dem Unterzeichner vertrauen und die Signatur überprüfen, können Sie sicher sein, dass die Daten nicht manipuliert wurden. Der gesamte Prozess funktioniert im Wesentlichen folgendermaßen:
1. Der Unterzeichner berechnet ein kryptografisches Hash der Daten. Ein Hash kann als lange Zeichenfolge betrachtet werden, die sich bei nur geringfügig abweichenden Dateneingaben stark unterscheidet.
1. Der Unterzeichner verschlüsselt dieses Hash mit dem geheimen Schlüssel so, dass es mit dem öffentlichen Schlüssel entschlüsselt werden kann. Das Ergebnis ist die Signatur. Beachten Sie, dass die Verwendung der Schlüssel hier genau gegenteilig zur typischen asymmetrischen Verschlüsselung ist.
1. Der Prüfer entschlüsselt die Signatur mit dem öffentlichen Schlüssel des Unterzeichners. Das Ergebnis ist das Hash. Der Prüfer weiß nun, dass das Hash vom Unterzeichner stammt, da nur dieser den geheimen Schlüssel besitzt, um eine Zeichenfolge so zu verschlüsseln, dass der öffentliche Schlüssel sie entschlüsseln kann.
1. Der Prüfer berechnet das Hash nun weiterhin selbstständig aus den Daten. Stimmt der Wert mit dem des Unterzeichners überein, weiß er, dass die Daten nicht verändert wurden.

Signaturen können entweder *inline* sein, werden also direkt an die zu signierenden Daten angehängt, oder sie können in einer separaten *Signaturdatei* vorliegen, wenn die Originaldaten das Anhängen einer Signatur nicht zulassen. Sequoia-PGP kann beide Fälle verarbeiten.

#### Cleartext vs. Message

Für Inline-Signaturen erkennt OpenPGP (und damit auch Sequoia-PGP) die Varianten "cleartext" ("Klartext") und "mesage" ("Nachricht").

Inline-signierte "cleartext" Daten sind in ihrer ursprünglichen Form in der Ausgabe enthalten. Die resultierende Struktur ist:

```
-----BEGIN PGP SIGNED MESSAGE-----
[Originaldaten]
-----BEGIN PGP SIGNATURE-----
[Signatur in Base64]
-----END PGP SIGNATURE-----
```

Dies ist nützlich, falls die Originaldaten von Menschen lesbar sind, und wird beispielsweise beim Signieren einer Security.txt empfohlen.

Bei der Variante "message" werden die Daten stattdessen in Base64 kodiert und mit der Signatur kombiniert. Die Ausgabe sieht dann folgendermaßen aus:

```
-----BEGIN PGP MESSAGE-----
[Daten und Signatur in Base64]
-----END PGP MESSAGE-----
```

Diese Variante ist kompakter, ein Mensch kann die Originaldaten jedoch vor der Dekodierung nicht mehr lesen.

### Daten signieren

Um eine Inline-Signatur von (beispielsweise) einer Textdatei zu erstellen, rufen Sie Folgendes auf:

{{< example sq_sign_inline >}}

Damit signiert Sequoia-PGP den Inhalt von "message.txt" mit dem geheimen Schlüssel in "example_secret.key" und speichert das Ergebnis in "signed_message.txt".

Der Parameter "cleartext" gibt an, dass die Originaldaten in ihrer ursprünglichen Form in die Ausgabe übernommen werden (siehe [oben](#cleartext-vs-message)).

Wenn Sie die Daten nicht in die Ausgabe aufnehmen, sondern eine separate Signaturdatei erstellen möchten, rufen Sie Folgendes auf:

{{< example sq_sign_signature_file >}}

Die [Dokumentation](https://book.sequoia-pgp.org/signing.html) enthält weitere Varianten zur Signaturerstellung.

### Signaturen verifizieren

Die Überprüfung einer separaten Signaturdatei ist recht einfach:

{{< example sq_verify_inline >}}

Dieser Befehl gibt die Datei mit der Originalnachricht, die zugehörige Signaturdatei und den öffentlichen Schlüssel des Unterzeichners an.

Die Überprüfung einer Inline-Signatur funktioniert ähnlich:

{{< example sq_verify_signature_file >}}

Die Option "cleartext" teilt Sequoia-PGP mit, dass die Datei signed_message.txt die Originalnachricht im Klartext enthält (siehe [oben](#cleartext-vs-message)).

> Falls Ihre Annahme bezüglich des Formats falsch ist, erkennt Sequoia-PGP dies und korrigiert es für Sie. Warum wird der Parameter überhaupt benötigt, wenn alle Informationen bereits in der Nachricht gespeichert sind? Wahrscheinlich aus historischen Gründen.

Der Befehl gibt die Originalmeldung auf die Standardausgabe und die Auswertung (Signatur ist gültig / ungültig) auf die Standardfehlerausgabe aus. Wenn Sie nur die Auswertung benötigen, fügen Sie dem obigen Befehl " > /dev/null" hinzu, um die Standardausgabe zu ignorieren.
