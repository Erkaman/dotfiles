#!/usr/bin/env bash

# This script converts PNG images to GIF images.

files="@$"

if [[ $# < 1 ]]
then
    echo "Defaulting to all PNG files in the current directory..."
    files=(*.png)
fi

temppnm="`tempfile`"

for file in "${files[@]}"
do
    echo "Converting $file to"

    pngtopnm "$file" > temppnm

    pnm
#    pnmtopng
    echo "$temppnm"



    outgif=$(basename "$file" .png).gif

    echo "$outgif"

done
