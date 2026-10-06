#!/bin/bash
# ctos-sound: play an audio file in every active graphical user session.
# Used by shutdown/reboot/suspend hooks, which run as root but must reach the
# user's PipeWire session.
#
# Uses setpriv (not runuser/su) to drop privileges: runuser tries to register a
# PAM/logind session, which fails once user.slice is frozen (UnitAllocationFailed).
# setpriv only changes uid/gid, so the player stays in system.slice and can still
# reach the PipeWire socket.
#
# Usage: ctos-sound /path/to/sound.ogg [volume]

SOUND="$1"
VOLUME="${2:-0.7}"

[ -n "$SOUND" ] && [ -f "$SOUND" ] || exit 0
command -v pw-play >/dev/null 2>&1 || exit 0
command -v setpriv >/dev/null 2>&1 || exit 0

played=0
rc=0
for runtime in /run/user/[0-9]*; do
  [ -S "$runtime/pipewire-0" ] || continue
  uid="${runtime##*/}"
  gid="$(id -g "$uid" 2>/dev/null)" || continue
  setpriv --reuid="$uid" --regid="$gid" --clear-groups \
    env XDG_RUNTIME_DIR="$runtime" \
    /usr/bin/pw-play --volume="$VOLUME" "$SOUND" >/dev/null 2>&1 &
  pids="$pids $!"
  played=1
done

# Wait for playback so shutdown doesn't tear the audio stack down mid-sound.
if [ "$played" -eq 1 ]; then
  for p in $pids; do wait "$p" || rc=$?; done
fi
exit $rc
