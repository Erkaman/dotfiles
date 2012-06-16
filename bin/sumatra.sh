#!/usr/bin/env bash

# Allows the usage of the awesome PDF reader SumatraPDF on linux using Wine.
# The SumatraPDF executable must be located at ~/bin/SumatraPDF.exe
# for this script to work

if [[ $# < 1 ]]
then
    echo "PDF was not supplied"
    exit 1
fi

wine ~/bin/SumatraPDF.exe "$1"

