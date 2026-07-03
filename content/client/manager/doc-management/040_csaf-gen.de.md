+++
title = "CSAF Generierung"
slug = "csaf-gen"
weight = 40
description = "Lernen Sie, wie sie CSAF Dokumente mit nur minimalem Eingaben im toml Format generieren können."
+++

Der [CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html) wurde entwickelt, um eine Vielzahl von Anwendungsfällen abzudecken. Das macht ihn zwar sehr mächtig, aber auch sehr komplex. Oftmals möchten Sie als Anbieter Ihren Kunden lediglich schnell mitteilen, ob Ihr Produkt von einer bestimmten Sicherheitslücke betroffen ist oder nicht.

Mit einem Tool wie [Secvisogram](/de/integration/secvisogram/) können Sie zwar in jedem Fall ein vollständiges CSAF-Dokument erstellen, dieser Prozess ist jedoch zeitaufwändig.

Ab Version 1.6.0 unterstützt BOMnipotent die Generierung von CSAF-Dokumenten aus wenigen Zeilen TOML-Eingabe. Dabei nutzt es die Tatsache, dass der Server Ihre Konfiguration bereits kennt, und trifft Annahmen, um fehlende Informationen zu ergänzen und so ein gültiges CSAF-Dokument zu erstellen.

## Nicht betroffenes Produkt

Die Eingabe, um mitzuteilen, dass Ihr Produkt nicht von einer Sicherheitslücke betroffen ist, sieht folgendermaßen aus:

{{< file "csaf_input_not_affected.toml" >}}

- Das Feld "titel" ist optional. Wird es weggelassen, generiert BOMnipotent einen Titel aus den anderen Eingaben (siehe unten).
- Das Feld "vuln" muss die ID der Sicherheitslücke enthalten, auf die sich das CSAF bezieht. Obwohl der CSAF-Standard die Beschreibung mehrerer Sicherheitslücken in einem einzigen Dokument erlaubt, ist der von BOMnipotent generierte Algorithmus aus Gründen der Übersichtlichkeit auf genau eine Sicherheitslücke ausgelegt. Liegt die ID im CVE-Format vor, wird das entsprechende Feld erstellt. Andernfalls versucht BOMnipotent, das Format zu erkennen und erstellt einen Eintrag im "ids"-Array der Sicherheitslücken des CSAF.
- Der CSAF-Standard schreibt vor, dass eine Sicherheitslücke mindestens einen "notes"-Eintrag haben muss. Daher ist das Eingabefeld "details" erforderlich. Die darin enthaltenen Informationen fassen die Arbeit des Sicherheitsexperten zusammen, der die Ausnutzbarkeit der Sicherheitslücke in Ihrem Produkt analysiert hat.
- Das Feld "tlp" ist optional, aber empfohlen.
- Kern eines CSAF-Dokuments ist die Verknüpfung zwischen Produkten und Sicherheitslücken. Dies wird über das Array "products" übermittelt. Jeder Eintrag enthält die folgenden Felder:
  - "name" und "version" müssen dem Namen und der Version einer BOM entsprechen, die Sie auf Ihren BOMnipotent-Server [hochgeladen](/de/client/manager/doc-management/boms/#hochladen) haben.
  - Der Status muss einem der im CSAF-Standard [definierten Werte](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3239-vulnerabilities-property---product-status) entsprechen. Die wichtigsten Informationen können Sie mit "known_affected" und "known_not_affected" übermitteln.
  - Die Felder "cpe" und "purl" können genutzt werden, um einen Wert für [Common Platform Enumeration](https://de.wikipedia.org/wiki/Common_Platform_Enumeration) und [Package Uniform Resource Locator](https://github.com/package-url/purl-spec) des Produkts anzugeben. Falls mindestens eines davon gesetzt ist, erstellt BOMnipotent einen [product identification helper](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#3133-full-product-name-type---product-identification-helper) Eintrag im Produktbaum.

  BOMnipotent verwendet diese Daten, um einen "product_tree" der in der Eingabe genannten Produkte zu generieren. Dieser Baum enthält Ebenen für "vendor", "product_name" und "product_version". Außerdem wird der Eintrag "vulnerabilities" im CSAF erstellt, in dem jedes Produkt mit seinem Status aufgeführt ist.
- Die Herausgeberdaten des CSAF-Dokuments stammen aus den [Provider Metadaten](/de/server/configuration/required/provider-metadata/), die für die Serverkonfiguration erforderlich sind.
- BOMnipotent geht davon aus, dass der Status dieses CSAF-Dokuments "final" und seine Version "1.0.0" ist. Es setzt den aktuellen Zeitstempel als "initial_release_date" sowie als "current_release_date" und erstellt die entsprechende "revision_history".
- Aus dem Produktnamen, der Sicherheitslücken-ID und dem aktuellen Datum wird eine ID für das CSAF generiert. Existiert diese ID bereits in der Datenbank, wird stattdessen eine Kombination aus Datum und Uhrzeit verwendet. Werden mehrere Produktnamen angegeben, wird der Herstellername als ID verwendet.

Um die CSAF-Datei zu generieren, speichern Sie die Eingabe in einer Datei und verwenden Sie diese als Argument für den Befehl "csaf generate".

{{< example "generate_csaf_not_affected" "1.6.0" >}}

Das CSAF wird generiert und direkt auf den Server hochgeladen.

{{< example "show_effect_not_affected" "1.6.0" >}}

## Betroffenes Produkt

Falls mindestens eine Produktversion von einer Sicherheitslücke betroffen ist erfordert der CSAF Standard, dass sie eine Gegenmaßnahme ("remediation") angeben:

{{< file "csaf_input_affected.toml" >}}

- Die "category" der Gegenmaßnahme muss eine der im CSAF Standard [definierten Werte](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#323121-vulnerabilities-property---remediations---category) haben.
- Das "details" Feld muss Informationen darüber enthalen, wie Kunden reagieren müssen.
- Das "url" Feld kann zum Beispiel auf eine Download-Webseite zeigen.

Der Rest der Vorgehensweise bleibt gleich.

{{< example "generate_csaf_affected" "1.6.0" >}}

{{< example "show_effect_affected" "1.6.0" >}}

## Zusammenfassen von Versionen

Wenn BOMnipotent nach dem Betroffenheitsstatus der Produkte sucht, überprüft es zuerst die exakten Übereinstimmungen von Name und Version. Findet es keine, dann vergleicht es mt den Einträgen, welche keine Version angeben. Dies können Sie nutzen, um zum Beispiel spezielle Angaben für eine Version zu machen, und für die anderen einen Standard-Betroffenheitsstatus anzugeben.

{{< file "csaf_input_globbing.toml" >}}

Die resultierende CSAF Liste sieht so aus:

{{< example "show_effect_globbing" "1.6.0" >}}

## Titelgenerierung

Falls Sie den Titel in der Eingabe auslassen generiert BOMnipontent einen:
- Der erste Teil des Titels ist der Produktname.
  - Falls mehr als ein Produktname in der Eingabe erwähnt wird fällt dies zurück auf "Several Products".
- Der zweite Teil wird "is affected", falls eine Produktversion betroffen ist. Er wird stattdessen "is not affected", falls keine Produktversion betroffen ist.
  - Dies wird das grammatikalisch korrekte "are (not) affected" falls der erste Teil "Several Products" lautet.
- Der dritte und letzte Teil lautet "by {vulnerability}, wobei hier die in der Eingabe angegeben ID der Sicherheitslücke verwendet wird.

{{< file "csaf_input_minimal.toml" >}}

Nach der Generierung des CSAFs sieht der Serverzustand wie folgt aus:

{{< example "show_effect_minimal" "1.6.0" >}}
