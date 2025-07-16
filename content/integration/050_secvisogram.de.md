+++
title = "CSAF Docs mit Secvisogram"
slug = "secvisogram"
weight = 50
description = "Leitfaden zur Erstellung und Validierung von CSAF-Dokumenten mit Secvisogram: Tipps, Produktbaum, Vulnerabilities und TLP-Klassifizierung."
+++

Das [Common Security Advisory Framework](https://www.csaf.io/specification.html) (CSAF) ist ein maschinenlesbares Format und ein internationaler Standard für den Informationsaustausch über Cyber-Sicherheitslücken. Es informiert Nutzer Ihres Produkts über die richtige Reaktion: Müssen sie auf eine neuere Version aktualisieren? Müssen sie eine Konfiguration ändern? Ist Ihr Produkt überhaupt betroffen oder ruft es den betroffenen Teil der anfälligen Bibliothek möglicherweise nie auf?

Der [CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html) von OASIS Open deckt ein sehr breites Spektrum an Szenarien ab. Aus diesem Grunde kann er zunächst sehr überwältigend sein. Diese Seite zeigt die wichtigsten Komponenten eines CSAF-Dokuments und bietet einen praktischen Leitfaden für den sofortigen Einstieg.

## Secvisogram

CSAF-Dokumente sind Dateien im JSON-Format, die einem bestimmten Schema folgen. Daher können sie grundsätzlich mit jedem Texteditor erstellt werden. CSAF-Dokumente müssen jedoch eine Vielzahl von Regeln einhalten, die jeder CSAF-Anbieter (und das schließt BOMnipotent mit ein) überprüfen muss.

Stattdessen wird die Verwendung von [Secvisogram](https://github.com/secvisogram/secvisogram) empfohlen. Es handelt sich um eine Open-Source-Serveranwendung mit grafischer Benutzeroberfläche, die ursprünglich vom Bundesamt für Sicherheit in der Informationstechnik (BSI) entwickelt wurde.

### Lokaler Editor

Der wohl bequemste Einstieg in das Schreiben von CSAF-Dokumenten ist das Forken des Repositorys [local_csaf_editor](https://github.com/aunovis/local_csaf_editor) der [AUNOVIS GmbH](https://www.aunovis.de/). Es enthält ein kleines Bash-Skript zum lokalen Klonen und Ausführen von Secvisogram. Es ermuntert Sie weiterhin dazu, versionierte CSAF-Vorlagen zu speichern, da einige Eigenschaften von Advisory zu Advisory immer gleich bleiben.

## Wichtige Einträge

Die Erstellung eines validen CSAF-Dokuments ist eine Reise, die Sie von sich selbst über Ihre Produkte bis hin zu den Sicherheitslücken führt, die sie plagen. Diese Seite ist Ihre Karte und Ihr Reisebegleiter.

### Wichtige Dokument Einträge

Dokumenteigenschaften liefern Informationen über das CSAF-Dokument selbst. Sie geben unter anderem Aufschluss darüber, wie es identifiziert werden kann, wer es wann erstellt hat, und mit wem es geteilt werden darf.

#### Titel

Der [Titel](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32111-document-property---title) des Dokuments soll dem menschlichen Leser den Inhalt des Dokuments verdeutlichen. Es ist sinnvoll, den Produktnamen und die Art der Sicherheitslücke im Titel anzugeben, es gibt jedoch keine formalen Einschränkungen.

> In Secvisogram finden Sie den Titel unter "Metadaten auf Dokumentebene".

#### Publisher

Der Abschnitt [Publisher](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3218-document-property---publisher) dient Ihrer eindeutigen Identifizierung als Herausgeber des Dokuments.

Er enthält die Pflichtfelder "Name", "Namespace" und "Category" sowie die optionalen Felder "Issuing Authority" und "Contact Details". Die hier angegebenen Werte sollten mit den Werten in Ihrer [Provider-Metadaten](/de/server/configuration/required/provider-metadata/#dateneingaben-des-herausgebers)-Konfiguration übereinstimmen, die für das Hosten von CSAF-Dokumenten erforderlich ist. Die Dokumentationsseite enthält weitere Informationen zu den hier anzugebenden Werten.

#### Tracking

Der Abschnitt [Tracking](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32112-document-property---tracking) enthält wichtige Metadaten zum Dokument. Er soll in erster Linie maschinenlesbar sein. Der erforderlichen Felder gibt es viele:

- [ID:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321124-document-property---tracking---id) Die ID dient zusammen mit Ihrem Herausgeber-Namespace zur Identifizierung eines Dokuments. Sie muss daher innerhalb Ihrer Organisation eindeutig sein. Darüber hinaus verlangt der Standard lediglich, dass die ID nicht mit einem Leerzeichen beginnt oder endet. Es wird jedoch empfohlen, nur Kleinbuchstaben, Ziffern sowie die Symbole "+", "-" und "_" zu verwenden, denn der Standard empfiehlt, dass [Dateinamen](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#51-filename) für CSAF-Dokumente diesem Muster folgen. Abweichungen davon können zu Verwirrung und sogar Konflikten führen. Es gibt keinen triftigen Grund dafür, dass eine ID nicht mit ihrem Dateinamen identisch sein sollte.
- [Initial Release Date](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321125-document-property---tracking---initial-release-date) (Erstveröffentlichungsdatum) und [Current Release Date](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321122-document-property---tracking---current-release-date) (Aktuelles Veröffentlichungsdatum) sind wunderbar selbsterklärende Felder.
- [Status:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321127-document-property---tracking---status) Dieser Status muss "draft" ("Entwurf"), "interim" ("Zwischenstand") oder "final" ("Endstand") sein. Der Status informiert Ihre Nutzer über die voraussichtliche Änderungsrate des Dokuments. Vor dem ursprünglichen Veröffentlichungsdatum muss der Status "draft" sein.
- [Version:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321128-document-property---tracking---version) Sie können entweder die [semantische Versionierung](https://semver.org/) oder eine [natürliche Zahl](https://www.cuemath.com/numbers/natural-numbers/) als Dokumentversion verwenden. Es wird empfohlen, mit 1 als (semantische) Major Version oder als natürliche Zahl zu beginnen. Bei jeder Änderung Ihres Dokuments müssen Sie die Version erhöhen. Bei semantischen Versionen bedeutet dies, dass mindestens die Patch-Version erhöht werden muss, während bei natürlichen Zahlenversionen die Zahl mindestens um 1 erhöht werden muss.
- [Revisionsverlauf:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#321126-document-property---tracking---revision-history) Dieser muss für jede veröffentlichte Version einen Eintrag mit Zeitstempel, Version und Zusammenfassung enthalten.

#### Distribution - TLP

Obwohl Sie das CSAF-Dokument nicht klassifizieren müssen, möchten Sie dies wahrscheinlich. Dies geschieht mithilfe des [Traffic Light Protocol (TLP)](https://www.first.org/tlp/), mit dem Sie die Informationen auf eine einzelne Person, eine Organisation und ihre Kunden, eine ganze Community oder gar nicht beschränken können.

Diese Klassifizierung hat programmatische Konsequenzen: Ein als {{<tlp-white >}} oder {{<tlp-clear >}} klassifiziertes Dokument wird von BOMnipotent öffentlich freigegeben, während Dokumente mit einer anderen Klassifizierung eine explizite Authentifizierung und Zugriff erfordern, um angezeigt zu werden.

Wenn Sie im Dokument keine Klassifizierung angeben, verwendet der BOMnipotent-Server ein konfigurierbares [Standard-TLP](/de/server/configuration/optional/tlp-config/#default-tlp). Dies bedeutet jedoch, dass die TLP-Informationen verloren gehen, sobald das Dokument vom Server heruntergeladen wird. Daher wird eine Klassifizierung im Dokument empfohlen.

Bitte beachten Sie, dass der [CSAF-Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32152-document-property---distribution---tlp) nur die Klassifizierung mit den veralteten [TLP v1.0](https://www.first.org/tlp/v1/) Labels vorsieht. Sofern Sie sich strikt daran halten, sollte die URL im Dokument https://www.first.org/tlp/v1/ lauten (dies entspricht nicht der von Secvisogram angebotenen URL).

Viele CSAF-Herausgeber bevorzugen jedoch die Klassifizierung ihrer Dokumente mit dem TLP v2.0 Label {{< tlp-amber-strict >}}, welches nur die Verteilung innerhalb einer Organisation erlaubt. Sie können BOMnipotent so [konfigurieren](/de/server/configuration/optional/tlp-config/#tlp-v20-zulassen), dass auch CSAF-Dokumente akzeptiert werden, die mit TLP v2.0-Labels klassifiziert sind.

### Wichtige Product Tree Einträge

Der Produktbaum enthält Informationen darüber, welche Produkte von dem Advisory abgedeckt sind. Diese sind in Zweige gruppiert, die, ähnlich wie Namespaces, zur Strukturierung Ihres Produktkatalogs dienen.

Erstellen Sie am besten eine Vorlage mit allen Ihren Produkten (oder Produktfamilien, falls dies Ihren Anforderungen besser entspricht). Das Löschen irrelevanter Produkte aus einem Dokument ist in Sekundenschnelle erledigt, das Hinzufügen fehlender Produkte birgt hingegen das Risiko, einige zu vergessen.

#### Branches

[Branches](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#312-branches-type) (Zweige) bestehen immer aus genau drei Feldern: einem [Namen](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3123-branches-type---name), einer [Kategorie](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3122-branches-type---category) und anschließend entweder einem [Produkt](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#313-full-product-name-type) oder weiterer Zweige.

Diese rekursive Definition sollte mit einem allgemeinen Überblick beginnen und dann bis zu den einzelnen Releases heruntergehen. Eine sehr plausible Struktur ist die folgende:
- Ein oberster Zweig mit der Kategorie "vendor" ("Anbieter"). Der Name entspricht dem Namen Ihrer Organisation.
- Der Zweig "vendor" enthält für jedes Ihrer Produkte einen Zweig mit der Kategorie "product_name" ("Produktname"). Sollten die Produkte zu zahlreich werden, können Sie sie zusätzlich in Zweigen mit der Kategorie "product_family" ("Produktfamilie") gruppieren.
- Jeder Zweig "product_name" enthält einen Zweig für jede "product_version" ("Produktversion"). Wichtig ist, dass der Name des Zweigs tatsächlich eine Version und nicht einen Versionsbereich darstellt. Dafür gibt es eine separate Kategorie.
Wenn Sie für verschiedene Architekturen entwickeln, empfiehlt sich die Einrichtung eines Unterzweigs mit der Kategorie "architecture".

Für welche Zweigstruktur Sie sich auch entscheiden, die untersten Zweige müssen ein Produktfeld enthalten. Dieses muss die folgenden Felder enthalten:
- [Name:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3131-full-product-name-type---name) Ein idealerweise eindeutiger Name, der menschlichen Lesern die Identifizierung des Produkts erleichtert. Dies kann auch die Verkettung aller Zweignamen sein, die zu diesem Punkt führen.
- [Produkt-ID:](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#318-product-id-type) Die Produkt-ID dient zur Referenzierung dieses Produkts im aktuellen Dokument. Es gelten keine besonderen Anforderungen, außer dass sie im Dokument eindeutig sein muss.

Das Produkt kann einen [Produktidentifizierungshelfer](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3133-full-product-name-type---product-identification-helper) enthalten. Dieser ist in erster Linie relevant, um anderen Personen die Identifizierung Ihres Produkts von außerhalb des aktuellen Dokuments zu erleichtern.

##### Zuordnung zu BOMs

BOMnipotent nutzt die product_name und product_version Einträge Ihrer Branches, um Produkt IDs von CSAF Dokumenten mit BOMs zu assoziieren. Dies befähigt es, zu [prüfen](/de/client/manager/doc-management/vulnerabilities/#auflisten), ob eine in einer BOM gefundene Sicherheitslücke von einem CSAF Dokument abgedeckt wird.

**Wichtig:** Falls der CSAF Branch, der zu einem Produkt führt, keinen product_name oder product_version Eintrag enthält, ist BOMnipotent nicht in der Lage, die Produkt ID mit einer BOM zu assoziieren.

Falls der Branch hingegen *mehr* als einen product_name oder product_version Eintrag hat, nutzt BOMnipotent jweils den *spezifischsten* Wert, welches der ist, der *am weitesten* unten in der Baumstruktur ist.

Als Beispiel betrachten Sie die folgende (schematische) Baumstruktur:
```
product_name: Umbrella
    product_version: 1.0.0
        product_id: umbrella_1.0.0
    product_version: 1.1.0
        product_name: Flowersheet
            product_id: umbrella_1.1.0_flowersheet
    architecture: linux
        product_id: umbrella_linux
```

Hier würde BOMnipotent die folgenden Zuordnungen machen:
- Die ID "umbrella_1.0.0" mit der BOM mit dem Namen "Umbrella" und der Version "1.0.0".
- Die ID "umbrella_1.1.0_flowersheet" mit der BOM mit Namen "Flowersheet" und Version "1.1.0" ("Flowersheet" wird als Produktname bevorzugt, weil es weiter unten in der Baumstruktur ist als "Umbrella").
- Die ID "umbrella_linux" mit gar keiner BOM, da sie keinen Eintrag für product_version hat.

### Wichtige Vulnerabilities Einträge

[Vulnerabilities](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#323-vulnerabilities-property) sind Einträge, die Ihren Nutzern mitteilen, welche Produkte (nicht) von einer Sicherheitslücke betroffen sind und welche Maßnahmen ergriffen werden müssen.

#### Titel

Der [Titel](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32315-vulnerabilities-property---title) dient dazu, menschlichen Lesern zu zeigen, welche Sicherheitslücke in diesem CSAF-Dokument behandelt wird.

#### CVE und IDs

Diese wichtigen Felder werden von Maschinen zur Identifizierung einer Sicherheitslücke verwendet. Es gibt verschiedene Systeme zur Identifizierung von Sicherheitslücken. Das bekannteste ist die [Common Vulnerabilities and Exposures (CVE)](https://www.cve.org/) Trackingnummer. Wenn für die Sicherheitslücke eine CVE-Nummer vorhanden ist, können Sie diese in das [entsprechende Feld](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3232-vulnerabilities-property---cve) eingeben.

Wird die Sicherheitslücke über ein anderes System verfolgt, können Sie deren ID im Feld [IDs](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3236-vulnerabilities-property---ids) angeben. Jeder Eintrag enthält zwei Felder:
- Systemname: Dient zur Identifizierung des Tracking-Systems. Dies kann beispielsweise "GitHub Security Advisories" oder "GitHub Issue" sein. Nur "CVE" ist nicht zulässig, da CVEs über das dedizierte Feld angegeben werden.
- Text: Der tatsächliche Wert der ID, z. B. "GHSA-abcd-efgh-ijkl" oder "Weichwerke-Heidrich-Software/bomnipotent_doc#37".

> *Hinweis*: In Secvisogram müssen Sie die "Aktive Relevanzstufe" auf 4 setzen, um IDs eingeben zu können, die keine CVEs sind.

#### Notes

Jede Sicherheitslücke muss mindestens eine [Notiz](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#315-notes-type) enthalten. Eine Notiz hat eine Kategorie und einen Inhalt. In den meisten Fällen reicht es aus, einen Hinweis mit der Kategorie "description" ("Beschreibung") hinzuzufügen und die Beschreibung der Sicherheitslücke aus der offiziellen Quelle zu übernehmen.

Anders verhält es sich natürlich, falls die Sicherheitslücke keine offizielle Beschreibung hat, weil sie direkt aus Ihrem Produkt stammt. In diesem Fall sollten Sie eine weitere Notiz mit der Kategorie "details" hinzufügen.

#### Produktstatus

Die Listen mit den [Produktstati](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#3239-vulnerabilities-property---product-status) können als das Herzstück des Advisorys verstanden werden. Sie sind maschinenlesbare Listen, die Informationen darüber enthalten, ob ein Produkt von einer Sicherheitslücke betroffen ist oder nicht. Es wird empfohlen, alle Ihre Product IDs (also alle Versionen aller Produkte) mindestens in die folgenden Kategorien zu sortieren:
- Known affected: Diese Versionen sind von der Sicherheitslücke betroffen.
- Fixed: Diese Versionen enthalten einen Fix und sind daher nicht von der Sicherheitslücke betroffen.
- Recommended: Dies ist die Version, die Sie zur Verwendung empfehlen. Sie sollte idealerweise auch in Ihrer Liste der behobenen Probleme aufgeführt sein.

Es kommt nicht selten vor, dass eine Sicherheitslücke in Ihrer Lieferkette Ihr Produkt nicht tatsächlich betrifft. Dies kann daran liegen, dass Ihr Produkt die anfälligen Pfade nie nutzt. In diesem Fall sollten Sie auch Einträge zu "known not affected" hinzufügen. Andernfalls werden Nutzer Ihres Produkts mit Zugriff auf Ihre SBOM möglicherweise über die Sicherheitslücke benachrichtigt und fragen nach, ob sie Maßnahmen ergreifen müssen.

> *Hinweis*: Im Secvisogram müssen Sie die "Aktive Relevanzstufe" auf 4 setzen, um alle verfügbaren Stati anzuzeigen.

#### Remediations

Für jedes betroffene (oder aktuell untersuchte) Produkt müssen Sie mindestens einen Eintrag erstellen, der eine [remediation](https://docs.oasis-open.org/csaf/csaf/v2.0/cs02/csaf-v2.0-cs02.html#32312-vulnerabilities-property---remediations) (Abhilfemaßnahme) beschreibt. Der Eintrag muss Folgendes enthalten:
- eine Kategorie, zum Beispiel "mitigation", "workaround" oder "no_fix_planned" (Risikoakzeptanz ist eine valide Strategie).
- Einzelheiten zur Anwendung der Abhilfemaßnahme oder warum keine Fehlerbehebung geplant ist.
- Ein Verweis auf mindestens eine Produkt-ID.
