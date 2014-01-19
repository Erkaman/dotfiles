#!/usr/bin/python

import sys
import subprocess
import os

mp4 = sys.argv[1]

if mp4[-4:] == "webm":
    ogg = mp4[:-5] + ".ogg"

    cmd = 'mkvmerge -i "{0}"'.format(mp4)
    p = os.popen(cmd)

    while True:
        s = p.readline()
        if s.find("audio") != -1:
            beg = s.find("ID ") + len("ID ")
            end = s.find(":")
            track = int(s[beg:end])
            break
    p.close()

    cmd = 'mkvextract tracks "{0}" {1}:"{2}"'.format(mp4, track, ogg)
    os.system(cmd)

#    mkvextract tracks file 2:audio.ogg

else:
    # mp3

    mp3 = mp4[:-4] + ".mp3"

    command = 'ffmpeg -i "{0}" -b:a 192K -vn "{1}"'.format(mp4, mp3)
    os.system(command)

