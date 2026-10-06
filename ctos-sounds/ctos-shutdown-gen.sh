#!/bin/bash
set -e
cd /tmp/opencode/ctos-down
SR=44100
mkdir -p build && cd build
rm -f *.wav

# Descending "ctOS powering down" chime.
# 1. First note (A5) - clean
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.30*sin(2*PI*880*t)*exp(-6*t):s=$SR:d=0.5" n1.wav
# 2. Second note (D5) - lower
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.30*sin(2*PI*587.33*t)*exp(-6*t):s=$SR:d=0.6" n2.wav
# 3. Downward glitchy sweep (power draining)
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.20*sin(2*PI*(900*t-700*t*t))*exp(-1.0*t)*(0.8+0.2*sin(2*PI*24*t)):s=$SR:d=1.3" sweep.wav
# 4. Low sub tail (shutting off)
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.45*sin(2*PI*55*t)*exp(-3.0*t):s=$SR:d=1.8" sub.wav
# 5. Final low confirm tone (G3)
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.22*sin(2*PI*196*t)*exp(-2.0*t):s=$SR:d=2.2" final.wav
# 6. Pink noise off-click
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "anoisesrc=d=0.10:c=pink:a=0.16" -af "highpass=f=600" glitch.wav

ffmpeg -y -hide_banner -loglevel error \
 -i n1.wav -i n2.wav -i sweep.wav -i sub.wav -i final.wav -i glitch.wav \
 -filter_complex "\
 [0]adelay=0|0[a];\
 [1]adelay=260|260[b];\
 [2]adelay=560|560[c];\
 [3]adelay=900|900[d];\
 [4]adelay=1250|1250[e];\
 [5]adelay=120|120[g];\
 [a][b][c][d][e][g]amix=inputs=6:duration=longest:normalize=0,alimiter=limit=0.95,afade=t=out:st=2.8:d=0.6[out]" \
 -map "[out]" -ar $SR ctos-shutdown.wav

ffmpeg -y -hide_banner -loglevel error -i ctos-shutdown.wav -c:a libvorbis -q:a 5 ctos-shutdown.ogg
echo "=== built ==="
ffprobe -hide_banner ctos-shutdown.ogg 2>&1 | grep -E "Duration|Stream"
ffmpeg -hide_banner -i ctos-shutdown.ogg -af volumedetect -f null - 2>&1 | grep -E "mean_volume|max_volume"
ls -lh ctos-shutdown.ogg | awk '{print $5, $9}'
