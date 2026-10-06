# tweakctl

One CLI to check & enable **hibernation**, pick **S3 deep sleep**, select a **Plymouth theme**, and pick/apply **ctOS sounds** — on **Arch, Ubuntu/Debian, Fedora/RHEL**.

## Install

### Arch (AUR-style, no root needed for PKGBUILD build)
```bash
cd tweakctl/packaging && makepkg -si
# or from the release asset:
sudo pacman -U tweakctl-0.1.0-1-any.pkg.tar.zst
```
To publish to the AUR, create an AUR4 account, then:
```bash
git clone ssh://aur@aur.archlinux.org/tweakctl.git
cp PKGBUILD tweakctl/; cd tweakctl && makepkg --printsrcinfo > .SRCINFO && git add -A && git commit -m init && git push
```

### Ubuntu / Debian (.deb)
```bash
sudo dpkg -i tweakctl_0.1.0_all.deb
# or build: cd tweakctl/packaging && ./build.sh
```

### Fedora / RHEL (.rpm)
```bash
sudo rpm -i tweakctl-0.1.0-1.noarch.rpm
# or build: cd tweakctl/packaging && ./build.sh
```

### Any distro (raw script)
```bash
git clone https://github.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks
cd linux-hibernate-dual-boot-tweaks/tweakctl
sudo cp tweakctl /usr/local/bin/
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
tweakctl sound list
tweakctl sound apply --name ctos-boot --volume 0.7
tweakctl update-check        # checks GitHub for newer release
```

TUI navigation: `↑`/`↓` to move, `Enter` to run, `q` to quit.

## How it works
- **Hibernate enable** detects your distro and either adds `resume=UUID=...` to GRUB (Arch/Ubuntu) and rebuilds initramfs (`mkinitcpio -P`/`update-initramfs -u`), or uses `grubby` + `dracut` on Fedora. Always creates the fstab swap line if missing.
- **S3** writes `mem_sleep_default=deep` to the same place your distro stores kernel args.
- **Plymouth** switches theme via `plymouth-set-default-theme` and rebuilds initramfs.
- **Sound** rewrites the systemd user unit to point at the chosen file and reloads it.

## Safety
- Every mutating command first prints what distro it detected.
- It never touches the Windows/NTFS partition.
- Always disable Windows Fast Startup before relying on hibernate on dual-boot.
