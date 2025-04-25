#!/bin/bash

set -e

toplevel="$(git rev-parse --show-toplevel)"

paths=$(find $toplevel/content/* -iname "*.md" | sort)

for path in $paths; do
    if [ -f "$path" ]; then
        git_last_modified=$(git log -1 --format="%ad" --date=format:"%Y-%m-%d" -- "$path")
        system_last_modified=$(stat -c "%y" "$path" | cut -d' ' -f1)
        if [ "$git_last_modified" != "$system_last_modified" ]; then
            echo "$path:"
            echo "  Git last modified: $git_last_modified"
            echo "  System last modified: $system_last_modified"
            echo "  Updating system modification date to match Git modification date..."
            touch -d "$git_last_modified" "$path"
        fi
    fi
done
