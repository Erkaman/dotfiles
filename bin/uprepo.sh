#!/usr/bin/env bash
# script to update all the git repositories.

echo "dotfiles:" && cd ~ && git pull origin && source .bashrc
echo "misc-scripts:" && cd ~/bin && git pull origin
echo "emacs:" && cd ~/.emacs.d/ && git pull origin
echo "conkeror:" && cd ~/.conkerorrc/ && git pull origin