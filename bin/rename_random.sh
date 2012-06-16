#!/usr/bin/env bash

randname=$RANDOM
file="$1"
ext=${file#*.}
randfilename="$randname.$ext"
mv "$file" "$randfilename"