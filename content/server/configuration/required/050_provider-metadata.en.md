+++
title = "CSAF Provider Metadata"
slug = "provider-metadata"
weight = 50
+++

The [OASIS Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#717-requirement-7-provider-metadatajson) requires that providers of CSAF documents offer a "provider-metadata.json", which needs to follow a [specific schema](https://docs.oasis-open.org/csaf/csaf/v2.0/provider_json_schema.json).

BOMnipotent strives to make it as easy as possible to fulfil this requirement. You can either [generate the file](#generating-data) from a few inputs, or [provide a file](#providing-filepath) for BOMnipotent to load.

## Generating Data

By providing some user-specific inputs, you can make BOMnipotent generate a valid provider-metadata.json file. This is much easier than creating the file by hand, but offers somewhat less control.

The relevant section in your config file looks like this:
```toml
[provider_metadata.publisher]
name = "<name of your organsiation>"
namespace = "https://<your-domain>.<top-level>"
category = "vendor"
issuing_authority = "<Additional info>" # Optional
contact_details = "<Please contact us at...>" # Optional
```

### Publisher Data Inputs

#### Name

This field requires you to provide the name of your company, organisation, or you as an individual.

#### Namespace

While the "name" field is primarily aimed at humans, the "namespace" is used by machines to identify your organisation across various security documents. It needs to be in URI format, including protocol, domain and top-level domain. Because it refers to your whole organisation, it should not contain a subdomain.

> This is what sets the "provider_metadata.publisher.namespace" field apart from the ["domain"](/server/configuration/required/domain/) configuration: The latter points to your instance of BOMnipotent Server, while the former is much more general.

#### Category

The publisher category is a machine readable classification of who you are. According to the [CSAF Standard](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#32181-document-property---publisher---category), the publisher categories allows the values "coordinator", "discoverer", "other", "translator", "user" or "vendor". As a user of BOMnipotent Server, you are most likely a "vendor", meaning a developer or maintainer of products or a service.

#### Issuing Authority

This optional field can be used to clarify your connection to the hosted documents. Are you the developer and maintainer? Are you the retailer? The input is in free form.

#### Contact Details

This optional field allows you to offer contact details for general or security inquiries. The input is a string in free form.

### Generated Document

Once you have provided the data and started the server, it will host it under "your-domain/.well-known/csaf/provider-metadata.json". You can see a live example [here](https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json) and a static example here:

```json {wrap="false" title="provider-metadata.json"}
{
    "canonical_url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/provider-metadata.json",
    "distributions": [
        {
            "rolie": {
                "feeds": [
                    {
                        "summary": "WHITE advisories",
                        "tlp_label": "WHITE",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/white/csaf-feed-tlp-white.json"
                    },
                    {
                        "summary": "GREEN advisories",
                        "tlp_label": "GREEN",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/green/csaf-feed-tlp-green.json"
                    },
                    {
                        "summary": "AMBER advisories",
                        "tlp_label": "AMBER",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/amber/csaf-feed-tlp-amber.json"
                    },
                    {
                        "summary": "RED advisories",
                        "tlp_label": "RED",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/red/csaf-feed-tlp-red.json"
                    },
                    {
                        "summary": "UNLABELED advisories",
                        "tlp_label": "UNLABELED",
                        "url": "https://bomnipotent.wwh-soft.com/.well-known/csaf/unlabeled/csaf-feed-tlp-unlabeled.json"
                    }
                ]
            }
        }
    ],
    "last_updated": "2025-03-06T16:13:24.632235974Z",
    "list_on_CSAF_aggregators": true,
    "metadata_version": "2.0",
    "mirror_on_CSAF_aggregators": true,
    "publisher": {
        "category": "vendor",
        "contact_details": "For security inquiries, please contact info@wwh-soft.com",
        "name": "Weichwerke Heidrich Software",
        "namespace": "https://wwh-soft.com"
    },
    "role": "csaf_provider"
}
```

This file contains a [ROLIE feed](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#7115-requirement-15-rolie-feed) for all your CSAF documents, which is probably the main reason why you do not want to create this document by hand.

The "last_updated" field is generated from the last modified timestamp of your config file.

BOMnipotent assumes that you want your CSAF documents listed and mirrored on publicly available repositories. This only concerns the documents labeled {{<tlp-white>}} / {{<tlp-clear>}}! The aggregators do not have access to any documents classified otherwisely.

BOMnipotent helps you fulfil all requirements to be a [CSAF Provider](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html#722-role-csaf-provider), according to the OASIS standard.


## Providing Filepath

If for some reason you want to have full control of the provider-metadata document, you can provide a filepath in the config file:

```toml
[provider_metadata]
path = "<filepath>"
```

BOMnipotent will then read the file, check that it follows the [provider-metadata json schema](https://docs.oasis-open.org/csaf/csaf/v2.0/provider_json_schema.json), and host it.

You have to provide **either** a path to a file, **or** publisher data. If you provide neither or both, the config will not be loaded.
