#!/bin/bash

set -e

# Change to git root directory
cd "$(git rev-parse --show-toplevel)"

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
    exit 1
else
    echo "No TODOs found."
fi

hugo list drafts
