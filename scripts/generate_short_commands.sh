#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

echo "= Generating short command variants ="

# This map maps long options to their corresponding short variants.
declare -A OPTION_MAP=(
  [--after]=-a
  [--before]=-b
  [--cpe]=-c
  [--csaf]=-c
  [--domain]=-d
  [--expired]=-e
  [--fail-on]=-f # This is grype syntax
  [--filename]=-f
  [--help]=-h
  [--id]=-i
  [--json]=-j
  [--log-level]=-l
  [--log-file]=-f
  [--name]=-n
  [--name-overwrite]=-n
  [--on-existing]=-o
  [--output]=-o
  [--output-mode]=-o
  [--overwrite]=-o
  [--permission]=-p
  [--purl]=-p
  [--robot]=-r
  [--role]=-r
  [--secret-key]=-s
  [--status]=-s
  [--tlp]=-t
  [--trusted-root]=-t
  [--type]=-t
  [--unassessed]=-u
  [--user]=-u
  [--version]=-v
  [--version-overwrite]=-v
  [--vulnerability]=-v
  [--year]=-y
)

input_files=$(find data/snippets -type f -name "*.in")

for file in $input_files; do
    short_file="${file%.in}.short"
    tmp_file="${file%.in}.tmp"
    
    for long in "${!OPTION_MAP[@]}"; do
        short="${OPTION_MAP[$long]}"

        # Some special cases handling
        if [[ "$long" == "--name-overwrite" || "$long" == "--version-overwrite" ]]; then
            if grep -q "bom modify" "$file"; then
                continue
            fi
        fi
        if grep -q "^sq " "$file"; then
            continue # Sequoia-PGP does not support short options
        fi

        if grep -q -e "$long " -e "$long=" -e "$long\$" "$file"; then
            if [ ! -f "$tmp_file" ]; then
                cp "$file" "$tmp_file"
            fi
            sed -i "s/$long /$short /g" "$tmp_file"
            sed -i "s/$long=/$short /g" "$tmp_file"
            sed -i "s/$long\$/$short/g" "$tmp_file"
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
    else
        if [ -f "$short_file" ]; then
            echo "Removing $short_file that should not exist."
            rm "$short_file"
        fi
    fi
done
