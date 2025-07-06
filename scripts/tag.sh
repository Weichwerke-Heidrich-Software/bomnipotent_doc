#!/bin/bash

set -e

cd "$(git rev-parse --show-toplevel)"

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" != "main" ]]; then
    echo "Not on main branch. Current branch: $branch"
    exit 1
fi

latest_changelog=$(ls -1 content/changelog/*.md | head -n 1 | xargs -n 1 basename)

if [[ -z "$latest_changelog" ]]; then
    echo "No changelog found in content/changelog/"
    exit 1
fi

semantic_version=$(echo "$latest_changelog" | \
    sed -E 's/^[0-9]+_(v[0-9]+-[0-9]+-[0-9]+)\..*$/\1/' | \
    sed 's:-:.:g')
echo "Extracted semantic version: $semantic_version"

if [[ -n $(git status --porcelain) ]]; then
    echo "Uncommitted changes present. Please commit or stash them before tagging."
    exit 1
fi

git tag --force "$semantic_version"
git push --force origin "$semantic_version"
