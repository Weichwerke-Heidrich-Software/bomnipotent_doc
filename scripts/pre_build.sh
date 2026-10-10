#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

cd themes/relearn
git fetch --tags --force
git checkout "$(git tag -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n1)"
cd -

./scripts/make_consistent.sh
./scripts/generate_short_commands.sh
./scripts/delete_empty_outputs.sh
