#!/usr/bin/env bash

# trashes all files that has the given extensions in a file.
# Packages needed: trash-cli

if [[ $# < 1 ]]
then
    echo "You need to supply at least one extension..."
    exit 1
fi

shopt -s nocaseglob

for file in "$@"
do
    echo "Trashing all $file files in folder..."

#    targetFiles=(*.$file)

    trash-put *.$file
done
