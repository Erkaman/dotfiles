#!/usr/bin/env bash

# This program optimizes PNG images by combining the PNG optimizer
# programs optipng, pngcrush and avpng.

files="@$"

if [[ $# < 1 ]]
then
    echo "Defaulting to all PNG files in the current directory..."
    files=(*.png)
fi

for file in "${files[@]}"
do
    img="$file"
    echo "File: $img"
    s1=$( stat -c %s "$img")

    echo "RUNNING OPTIPNG"
    optipng -o7 "$img"

    echo "RUNNING ADVPNG"
    advpng -z -4 "$img"

    optimg="$img".opt

    echo "RUNNING PNGCRUSH"
    pngcrush -brute "$img" "$optimg"
    rm "$img"
    cp "$optimg" "$img"
    rm "$optimg"

    s2=$( stat -c %s "$img")

    echo "Size before optimization: $s1"
    echo "Size after optimization: $s2"
    echo "$(($s1 - $s2)) bytes were saved."
done
# pngnq