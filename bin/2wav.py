#!/usr/bin/python
import os
import sys
import os.path

in_name = sys.argv[1]

wav_name = os.path.splitext(in_name)[0] + ".wav"
cmd = "ffmpeg -i {0} {1}".format(in_name, wav_name)

"ffmpeg -i river2.aiff -c:a libvorbis -q:a 8 {1}"

print cmd

os.system(cmd)
