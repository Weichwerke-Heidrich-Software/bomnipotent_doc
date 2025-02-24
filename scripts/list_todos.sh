#!/bin/bash

set -e

# Change to git root directory
cd "$(git rev-parse --show-toplevel)"

echo
echo "Drafts:"
hugo list drafts
echo

echo
./scripts/missing_translations.sh
echo

echo
./scripts/missing_description.sh
echo

SCRIPT=$(readlink -f "$0")

output=$(grep -rinI todo * \
    --include=\*.{md,sh,toml,yml,yaml} \
    --exclude-dir={.git,.vscode,themes} \
    --exclude="$(basename "$SCRIPT")" \
    -B 3 -A 3 || true)
if [ -n "$output" ]; then
    count=$(echo "$output" | grep -i todo | wc -l)
    echo "$output"
    echo
    echo "$count TODOs found!"
else
    echo "No TODOs found."
fi
