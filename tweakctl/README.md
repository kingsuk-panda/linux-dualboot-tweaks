# tweakctl

One CLI to check & enable **hibernation**, pick **S3 deep sleep**, select a **Plymouth theme**, and pick/apply **ctOS sounds** — on **Arch, Ubuntu/Debian, Fedora/RHEL**.

## Install

### Any distro — one line (curl)
```bash
curl -fsSL https://raw.githubusercontent.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks/main/install.sh | bash
```
Installs to `~/.local/bin` (add `--system` for `/usr/local/bin`, `--uninstall` to remove).
Only requirement: `python3`. Works on Arch, Debian/Ubuntu, Fedora, openSUSE, Alpine, Nix-ish setups — anything with python3.

### npm
```bash
npm i -g tweakctl      # same tool, shipped as an npm package
```

### Arch (AUR-style, no root needed for PKGBUILD build)
```bash
cd tweakctl/packaging && makepkg -si
# or from the release asset:
sudo pacman -U tweakctl-0.6.0-1-any.pkg.tar.zst
```
To publish to the AUR, create an AUR4 account, then:
```bash
git clone ssh://aur@aur.archlinux.org/tweakctl.git
cp PKGBUILD tweakctl/; cd tweakctl && makepkg --printsrcinfo > .SRCINFO && git add -A && git commit -m init && git push
```

### Ubuntu / Debian (.deb)
```bash
sudo dpkg -i tweakctl_0.6.0_all.deb
# or build: cd tweakctl/packaging && ./build.sh
```

### Fedora / RHEL (.rpm)
```bash
sudo rpm -i tweakctl-0.6.0-1.noarch.rpm
# or build: cd tweakctl/packaging && ./build.sh
```

## Usage

Run the friendly TUI (no args):

```bash
tweakctl            # or: tweakctl tui
```

Or the direct commands:

```bash
tweakctl hibernate check     # is hibernation working? swap, resume=, hooks
tweakctl hibernate enable    # auto-configure resume= + initramfs + fstab
tweakctl s3 check
tweakctl s3 set-deep         # force S3 instead of s2idle
tweakctl plymouth check
tweakctl plymouth apply --theme watch-dogs
tweakctl plymouth preview    # play the real boot splash on screen (or open the animation)
tweakctl sound list
tweakctl sound preview --name ctos-boot     # listen before applying
tweakctl sound apply --name ctos-boot --volume 0.7
tweakctl update-check        # checks GitHub for newer release
tweakctl disclaimer          # the full risk disclaimer — read it once
```

**First run:** the TUI shows a red **“USE AT YOUR OWN RISK”** disclaimer once —
`y` accepts (saved to `~/.config/tweakctl/`), `n` quits without touching
anything. The same text lives in `tweakctl disclaimer`, in *About & disclaimer*
and in the repo README.

TUI navigation: `↑`/`↓` (or `j`/`k`) to move, `Home`/`End` to jump, `Enter` to run, `PgUp`/`PgDn` to scroll long output, `q` (or `Esc`) to quit. **Pickers** (themes, sounds) use the same keys plus any letter to jump to the next entry starting with it; `Enter` selects, `Esc` cancels. Long output is word-wrapped to the pane — nothing is cut off.

If something is **already enabled** (hibernation working, deep sleep active, theme already selected, boot sound set), the TUI shows an **“Are you sure?”** screen explaining exactly what would change — `y` continues, `n`/`Esc` cancels with nothing modified.

**Previews:**
- `Sound > Preview a sound` opens a picker of every sound tweakctl can find (current boot sound marked `• current`) — arrow down, press `Enter`, and it plays.
- `Plymouth > Preview animation` opens a theme picker (active theme marked `• active`); choosing another theme switches to it **temporarily**, plays the real boot splash for ~8 s, then restores your original theme. Falls back to opening the animation as a GIF.

## How it works
- **Hibernate enable** detects your distro and either adds `resume=UUID=...` to GRUB (Arch/Ubuntu) and rebuilds initramfs (`mkinitcpio -P`/`update-initramfs -u`), or uses `grubby` + `dracut` on Fedora. Always creates the fstab swap line if missing.
- **S3** writes `mem_sleep_default=deep` to the same place your distro stores kernel args.
- **Plymouth** switches theme via `plymouth-set-default-theme` and rebuilds initramfs.
- **Sound** rewrites the systemd user unit to point at the chosen file and reloads it.

## Safety & disclaimer
- **Use it at your own risk.** The author is not responsible for a bricked
  laptop, lost data or a broken Windows install — there is no warranty
  (MIT, “as is”). Back up first, keep a recovery USB ready. The full text is
  in `tweakctl disclaimer`, in the TUI's *About & disclaimer* screen and in the
  [README](../README.md#disclaimer).
- Every mutating command first prints what distro it detected.
- It never touches the Windows/NTFS partition.
- **Dual-boot:** `tweakctl hibernate check` warns automatically when a Windows
  partition is found. Always disable Windows Fast Startup (and don't resume a
  Linux hibernation after booting Windows) before relying on hibernate.
