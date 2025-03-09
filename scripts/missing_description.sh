#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"
cd content

suggested_english_prompt="""
Generate a description for the page to be used for search engine optimization (SEO). The description should be a short summary of the page content, and should be between 100 and 145 characters. It should be informative and contain relevant keywords. Respond with just the description, in English, nothing else.
"""

suggested_german_prompt="""
Generiere eine Beschreibung für die Seite, die für die Suchmaschinenoptimierung (SEO) verwendet wird. Die Beschreibung sollte eine kurze Zusammenfassung des Seiteninhalts sein und zwischen 100 und 145 Zeichen lang sein. Sie sollte informativ sein und relevante Schlüsselwörter enthalten. Antworte nur mit der Beschreibung, auf Deutsch, mit nichts anderem.
"""

count=0
for file in $(find . -name "*.md"); do
    if grep -q "draft = true" $file; then
        continue
    fi
    if grep -q "robots =" $file; then
        continue
    fi
    if ! grep -q "description = " $file; then
        echo "Missing description: $file"
        count=$((count+1))
    fi
done

if [ $count -gt 0 ]; then
    echo "Found $count missing descriptions for published pages!"
fi
