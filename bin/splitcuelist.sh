#!/usr/bin/env bash

if [[ $# != 2 ]]
then
    echo "Please, supply the cuelist first, and second the file."
    exit 1
fi


cuebreakpoints "$1" | shnsplit -o flac "$2"