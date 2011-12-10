# aliasaes for making and decompressing tarballs.
alias untarball="tar xzfv"
alias tarball="tar cvzf"

# just run a command and ignore all of its output.
justopen(){ $1 >& /dev/null & }
