#!/usr/bin/env bash

# This program losslessly optimizes JPEG images by using the proggram jpegtran

files="@$"

if [[ $# < 1 ]]
then
    echo "Defaulting to all JPEG files in the current directory..."
    shopt -s nocaseglob
    files=(*.jpg)
fi

for file in "${files[@]}"
do
    echo "File: $file"

    s1=$( stat -c %s "$file")

    echo "RUNNING JPEGTRAN"
    opt="$file".opt
    jpegtran -optimize -copy none "$file" > opt
    cp opt "$file"
    rm opt

    s2=$( stat -c %s "$file")

    echo "Size before optimization: $s1"
    echo "Size after optimization: $s2"
    echo "$(($s1 - $s2)) bytes were saved."
done

