#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

rm -rf public

./scripts/make_consistent.sh

./scripts/generate_short_commands.sh

./scripts/delete_empty_outputs.sh

if [[ -n $(git status --porcelain) ]]; then
  echo "Error: You have unstaged changes."
  git status
  exit 1
fi

./scripts/infer_modify_date_from_git.sh

hugo
