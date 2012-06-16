#!/usr/bin/env bash

# This script converts RIS citation files to BibTeX citations using
# the BibUtils package.

files="@$"

if [[ $# < 1 ]]
then
    echo "Converting all the RIS file in the current directory...."
    shopt -s nocaseglob
    files=(*.ris)
#    exit 1
fi

for file in "${files[@]}"
do
    echo "Converting $file..."
    outbib=$(basename "$file" .ris).bib
    ris2xml "$file" | xml2bib >  "$outbib"
done