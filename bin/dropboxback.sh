#!/usr/bin/env bash
# script to backup dropbox. .

set -x
rm -rf ~/backdropbox/
mkdir ~/backdropbox/
cp -r ~/Dropbox/ ~/backdropbox/
set +x
