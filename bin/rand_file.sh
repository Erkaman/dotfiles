if [[ $# != 2 ]]
then
    echo "Please supply a valid file name(1) and file size(2)"
    exit
fi

dd if=/dev/urandom of="$1" bs=1k count="$2"
