#!/usr/bin/env bash
# script to update all the git repositories.

set -x
rm -rf ~/backdropbox/
mkdir ~/backdropbox/
cp -r ~/Dropbox/ ~/backdropbox/
set +x
