#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

# This map maps long options to their corresponding short variants.
declare -A OPTION_MAP=(
  [--domain]=-d
  [--robot]=-r
  [--user]=-u
)

input_files=$(find data/snippets -type f -name "*.in")

for file in $input_files; do
    short_file="${file%.in}.short"
    tmp_file="${file%.in}.tmp"
    
    for long in "${!OPTION_MAP[@]}"; do
        short="${OPTION_MAP[$long]}"
        long_with_arg="${long}="
        short_with_arg="${short} "
        if grep -q -- "$long" "$file"; then
            if [ ! -f "$tmp_file" ]; then
                cp "$file" "$tmp_file"
            fi
            sed -i "s/$long_with_arg/$short_with_arg/g" "$tmp_file"
            sed -i "s/$long/$short/g" "$tmp_file"
        fi
    done

    if [ -f "$tmp_file" ]; then
        if [ ! -f "$short_file" ]; then
            echo "Creating $short_file"
            mv "$tmp_file" "$short_file"  
        elif cmp -s "$tmp_file" "$short_file"; then
            rm "$tmp_file" # No changes detected
        else
            echo "Updating $short_file"
            mv "$tmp_file" "$short_file"
        fi
    fi
done
