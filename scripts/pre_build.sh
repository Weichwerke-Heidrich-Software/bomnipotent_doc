#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

cd themes/relearn
git checkout main
git pull
cd -

./scripts/make_consistent.sh
./scripts/generate_short_commands.sh
./scripts/delete_empty_outputs.sh
