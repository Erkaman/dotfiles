# aliasaes for making and decompressing tarballs.
alias untarball="tar xzfv"
alias tarball="tar cvzf"
alias o=exo-open

# just run a command and ignore all of its output.
just-open(){ $1 >& /dev/null & }

just-wmg-open(){ exec o $1 >& /dev/null & }

#play-all-files(){ exec "just-open "gnome-mplayer *.mp3"" }

# makes bash match filesnames in a case insensitive manner.
shopt -s nocaseglob

PATH="$HOME/bin:$PATH"