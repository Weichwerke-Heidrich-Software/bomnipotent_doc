#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

echo "= Deleting empty output files ="

output_files=$(find data/snippets -type f -name "*.out")
for file in $output_files; do
    if [ -z "$(cat $file)" ]; then
        echo "Deleting empty file: $file"
        rm "$file"
    fi
done
