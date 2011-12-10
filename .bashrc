# aliasaes for making and decompressing tarballs.
alias untarball="tar xzfv"
alias tarball="tar cvzf"

# just run a command and ignore all of its output.
just-open(){ $1 >& /dev/null & }

just-gnome-open(){ exec gnome-open $1 >& /dev/null & }
