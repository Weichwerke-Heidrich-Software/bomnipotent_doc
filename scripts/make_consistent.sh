#!/bin/bash

set -e

toplevel=$(git rev-parse --show-toplevel)

fileendings=(".en.md" ".de.md")

collect_paths() {
    find $toplevel/content/* | grep -v '_index' | sort
}

get_weight() {
    path=$1
    weight=$(basename $path | grep -o '[0-9]\+_')
    weight=${weight%_}
    weight=$(echo $weight | sed 's/^0*//')
    echo $weight
}

get_slug_from_dir() {
    path=$1
    slug=$(basename $path | sed 's/^[0-9]\{3\}_//')
    echo $slug
}

get_slug_from_file() {
    path=$1
    slug=$(basename $path | sed 's/^[0-9]\{3\}_//' | sed 's/\.en\.md//' | sed 's/\.de\.md//')
    echo $slug
}

check_slug_consistency() {
    slug=$1
    if echo $slug | grep "_" > /dev/null; then
        echo "Warning: Slug $slug contains underscore"
    fi
    if echo $slug | grep " " > /dev/null; then
        echo "Warning: Slug $slug contains space"
    fi
    if echo $slug | grep -E "[A-Z]" > /dev/null; then
        echo "Warning: Slug $slug contains uppercase letters"
    fi
    if echo $slug | grep -E "[^a-z0-9-]" > /dev/null; then
        echo "Warning: Slug $slug contains invalid characters"
    fi
}

make_file_consistent() {
    file=$1
    weight=$2
    slug=$3
    check_slug_consistency $slug
    if ! grep "^weight =" $file > /dev/null; then
        echo "Warning: No line starting with 'weight =' found in $file"
    else
        sed -i "s/^weight =.*/weight = $weight/" $file
    fi
    if ! grep "^slug =" $file > /dev/null; then
        echo "Warning: No line starting with 'slug =' found in $file"
    else
        sed -i "s/^slug =.*/slug = \"$slug\"/" $file
    fi
}

make_dir_consistent() {
    dir=$1
    weight=$2
    slug=$3
    for ending in ${fileendings[@]}; do
        if [ -f $dir/_index$ending ]; then
            make_file_consistent $dir/_index$ending $weight $slug
        elif [ -f $dir/index$ending ]; then
            make_file_consistent $dir/index$ending $weight $slug
        fi
    done
}

make_consistent() {
    path=$1
    weight=$(get_weight $path)
    if [ -z $weight ]; then
        echo "Warning: No weight found for $path"
        return
    fi
    if [ -d $path ]; then
        slug=$(get_slug_from_dir $path)
        make_dir_consistent $path $weight $slug
    elif [ -f $path ]; then
        slug=$(get_slug_from_file $path)
        make_file_consistent $path $weight $slug
    fi
}

for path in $(collect_paths); do
    make_consistent $path
done
