# decompress a tar gzipped file.
alias untar="tar xzfv"

# just run a command and ignore all of its output.
justopen(){ $1 >& /dev/null & }
