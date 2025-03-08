+++
title = "TLP Config"
slug = "tlp-config"
weight = 30
+++

CSAF documents can and in fact should be classified using the [Traffic Light Protocol (TLP)](https://www.first.org/tlp/). It clarifies if and with whom you can share documents that you have access to. The somewhat older TLP v1.0 standard knows four different classifications:
- {{<tlp-red>}}: This document may not be disclosed to anyone else.
- {{<tlp-amber>}}: This document can be spread on a need-to-know basis within their organization and its clients.
- {{<tlp-green>}}: This document can spread this within the recipient's community.
- {{<tlp-white>}}: There is no limit on disclosure.

The more current TLP v2.0 standard replaces {{<tlp-white>}} with {{<tlp-clear>}}, and adds the new classification {{<tlp-amber-strict>}}, which only allows sharing on a need-to-know basis with the recipient's organisation, but not beyond.

> Documents hosted by BOMnipotent Server that are classified as {{<tlp-white>}} or {{<tlp-clear>}} are visible to **everyone**, be they admin, completely unauthenticated user or crawler bot!

The "tlp" section of your configuration file may contain the following fields:
```toml
[tlp]
allow_tlp2 = true # Default is false
default_tlp = "amber+strict" # Default is "red"
```

## Allowing TLP v2.0

The current [OASIS CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#32152-document-property---distribution---tlp) requires documents to be classified with TLP v1.0 labels. However, many companies would prefer to use the {{<tlp-amber-strict>}} classification from the TLP v2.0 standard for their documents. Furthermore, the TLP v2.0 standard [will become mandatory](https://github.com/oasis-tcs/csaf/pull/720) once the CSAF standard 2.1 is released.

To be fully compliant with the CSAF standard, BOMnipotent does not allow TLP v2.0 labels by default. You can, however, set the field "allow_tlp2" to true in the "tlp" section of your config file:
```toml
[tlp]
allow_tlp2 = true
```

If you do, both TLP v1.0 and TLP v2.0 labels will be accepted.

If you do not, and BOMnipotent encounters TLP v2.0 labels, it will silently convert {{<tlp-clear>}} to {{<tlp-white>}}. Because {{<tlp-amber-strict>}} has no direct equivalent in TLP v1.0, BOMnipotent will take the conservative approach, convert it to {{<tlp-red>}}, and log a warning.

## Default TLP

Classifying a CSAF document with a TLP label is optional, and a TLP classification is not even part of the CycloneDX standard for BOM documents. BOMnipotent needs to at least know if the document is labelled {{<tlp-clear>}} / {{<tlp-white>}} and thus publicly available, or if access to it is restricted.

It is good practice to define a TLP classification that BOMnipotent can fall back to for an unlabelled document. You can do that in your config file via:
```toml
[tlp]
default_tlp = "amber"
```

> The deserialisation gives you some leeway: It does not consider the casing, and the "TLP:" prefix is optional. The values "amber", "AMBER", "tlp:amber" and "TLP:AMBER" are all recognised as {{<tlp-amber>}}.

If you do not provide a default TLP label, and BOMnipotent encounters an unlabelled document, it will default to {{<tlp-red>}} and log a warning.

The default TLP label is evaluated **at the time of access**, not at the time of writing. Unlabelled documents remain unlabelled in the database. If at any point you change the default TLP label, you change it for all unlabelled documents of past and future .
