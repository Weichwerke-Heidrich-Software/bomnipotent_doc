#!/bin/bash

set -e

toplevel=$(git rev-parse --show-toplevel)

make_consistent() {
    dir=$1
    for i in {0..100}; do
        weight_str=$(printf "%03d" $i)_
        for path in $dir/$weight_str*; do
            if [ -d $path ]; then
                echo "Processing $path"
                if [ -f $path ]; then
                    echo bla
                elif [ -d $path ]; then
                    cd $path
                    make_consistent $path
                    cd ..
                fi
            fi
        done
    done
}

make_consistent $toplevel/content
