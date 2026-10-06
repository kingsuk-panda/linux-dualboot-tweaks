# ctOS Sounds

Custom Watch Dogs-style ctOS sounds for boot, shutdown, and hibernate.

## Components

### `/usr/local/bin/ctos-sound`
Plays an audio file in every active graphical session. Uses `setpriv` (not `runuser`/`su`) because `runuser` tries to register a PAM/logind session, which fails once `user.slice` is frozen. Iterates over `/run/user/*/pipewire-0` sockets and plays with `pw-play --volume=...`.

Usage:
```bash
ctos-sound /path/to/sound.ogg [volume]
```

### Sound files — `/usr/share/sounds/ctos/`
- `ctos-shutdown.ogg`
- `ctos-boot.ogg`

### Boot sound — `~/.config/systemd/user/ctos-boot-sound.service`
Plays `ctos-boot.ogg` at login (`WantedBy=graphical-session.target`).

### Shutdown sound — `/etc/systemd/system/ctos-sound-shutdown.service`
`ExecStop` plays the shutdown sound before poweroff/halt. Triggers only on poweroff/halt, not reboot. Uses inverse ordering: `After=user@1000.service` so the unit stops before the user session (which owns PipeWire), letting the sound play while audio is alive.

### Hibernate sounds
- `ctos-hibernate-on.service` — plays shutdown sound before `sleep.target`/`systemd-hibernate.service` freezes user.slice; touches `/run/ctos-hibernated` marker.
- `ctos-hibernate-off.service` — after resume, if marker exists, plays `ctos-boot.ogg`.

All three services are enabled system-wide (`systemctl list-unit-files --state=enabled`).
