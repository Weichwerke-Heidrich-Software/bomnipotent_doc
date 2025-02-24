#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"
cd content

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
    echo "Found $count missing translations for published pages!"
fi
