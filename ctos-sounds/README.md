# ctOS Sounds — Arch / Ubuntu / Fedora + KDE/GNOME

Watch Dogs-style ctOS sounds for boot, shutdown, and hibernate/suspend.

## Components

### `/usr/local/bin/ctos-sound`
Plays an audio file in every active graphical session. Uses `setpriv` (not `runuser`/`su`) because `runuser` tries to register a PAM/logind session, which fails once `user.slice` is frozen. Iterates `/run/user/*/pipewire-0` sockets and plays via `pw-play --volume=...`.

```bash
ctos-sound /path/to/sound.ogg [volume]
```

### Sound files — `/usr/share/sounds/ctos/`
`ctos-shutdown.ogg`, `ctos-boot.ogg`

### Boot sound — `~/.config/systemd/user/ctos-boot-sound.service`
Plays `ctos-boot.ogg` at login. Works on KDE/GNOME/any session using systemd user manager + PipeWire.

### Shutdown sound — `/etc/systemd/system/ctos-sound-shutdown.service`
`ExecStop` plays the shutdown sound on poweroff/halt (not reboot). `After=user@1000.service` ensures the unit stops *before* the user session dies, so audio is alive during playback.

### Hibernate/suspend sounds
- `ctos-hibernate-on.service` — plays sound before `user.slice` freeze; touches `/run/ctos-hibernated`.
- `ctos-hibernate-off.service` — if marker present, plays boot sound on resume.

## Applicability
- **Arch / Ubuntu / Fedora:** same systemd unit files work; only the player differs.
- **Audio stack:** PipeWire required for `pw-play` (default on modern KDE/GNOME). On PulseAudio use `paplay`, ALSA use `aplay`.
- **GNOME:** same; just make sure the gdm/user session starts PipeWire before graphical-session sounds run.

## Limitations
- No sound on pure TTY sessions (no PipeWire socket).
- Sound may be missed if shutdown sound file is slow to decode — keep timeout (`TimeoutStopSec=15`).

## Bundled files
- `ctos-sound` → copy to `/usr/local/bin/`
- `ctos-shutdown.ogg` / `ctos-boot.ogg` → copy to `/usr/share/sounds/ctos/` (boot sound expects `~/.local/share/sounds/ctos-boot.ogg`)
- `ctos-hibernate-on.service`, `ctos-hibernate-off.service`, `ctos-sound-shutdown.service` → `/etc/systemd/system/`, then `sudo systemctl enable <name>`
- `ctos-boot-sound.service` → `~/.config/systemd/user/`, then `systemctl --user enable ctos-boot-sound.service`
- `ctos-gen.sh`, `ctos-shutdown-gen.sh`, `ctos-sound-helper.sh` — sound generation helpers
