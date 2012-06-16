#!/bin/bash
FLAC=$1
MP3="${FLAC%.flac}.mp3"
[ -r "$FLAC" ] || { echo can not read file \"$FLAC\" >&1 ; exit 1 ; } ;
metaflac --export-tags-to=- "$FLAC" | sed 's/=\(.*\)/="\1"/' >tmp.tmp
cat tmp.tmp
. ./tmp.tmp
rm tmp.tmp
flac -dc "$FLAC" | lame -b 192 -h --tt "$TITLE" \
--tn "$TrackNumber" \
--tg "$GENRE" \
--ty "$Date" \
--tc "$COMMENT" \
--ta "$ARTIST" \
--tl "$ALBUM" \
--add-id3v2 \
- "$MP3"