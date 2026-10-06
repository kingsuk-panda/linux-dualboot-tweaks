#!/bin/bash
set -e
cd /tmp/opencode/ctos
SR=44100
mkdir -p build && cd build
rm -f *.wav

# 1. Sub bass thump (ctOS power-up)
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.6*sin(2*PI*52*t)*exp(-7*t):s=$SR:d=0.7" sub.wav
# 2. Digital beep high
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.35*sin(2*PI*1568*t)*exp(-9*t):s=$SR:d=0.25" beep1.wav
# 3. Digital beep low
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.35*sin(2*PI*1046*t)*exp(-9*t):s=$SR:d=0.25" beep2.wav
# 4. Rising glitchy sweep
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=0.22*sin(2*PI*(300*t+850*t*t))*exp(-1.2*t)*(0.8+0.2*sin(2*PI*30*t)):s=$SR:d=1.4" sweep.wav
# 5. Final ctOS confirm chord (C5 E5 G5)
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "aevalsrc=(0.18*sin(2*PI*523.25*t)+0.15*sin(2*PI*659.25*t)+0.13*sin(2*PI*783.99*t))*exp(-2.2*t):s=$SR:d=2.6" chord.wav
# 6. Pink noise glitch
ffmpeg -y -hide_banner -loglevel error -f lavfi -i "anoisesrc=d=0.12:c=pink:a=0.18" -af "highpass=f=800" glitch.wav

# Assemble
ffmpeg -y -hide_banner -loglevel error \
 -i sub.wav -i beep1.wav -i beep2.wav -i sweep.wav -i chord.wav -i glitch.wav \
 -filter_complex "\
 [0]adelay=0|0[a];\
 [1]adelay=150|150[b];\
 [2]adelay=330|330[c];\
 [3]adelay=500|500[d];\
 [4]adelay=1500|1500[e];\
 [5]adelay=520|520[g];\
 [a][b][c][d][e][g]amix=inputs=6:duration=longest:normalize=0,alimiter=limit=0.95,afade=t=out:st=3.6:d=0.6[out]" \
 -map "[out]" -ar $SR ctos-boot.wav

echo "=== built ==="
ffprobe -hide_banner ctos-boot.wav 2>&1 | grep -E "Duration|Stream"
ls -lh ctos-boot.wav | awk '{print $5, $9}'
