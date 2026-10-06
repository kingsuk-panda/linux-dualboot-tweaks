# tweakctl

One CLI to check & enable **hibernation**, pick **S3 deep sleep**, select a **Plymouth theme**, and pick/apply **ctOS sounds** — on **Arch, Ubuntu/Debian, Fedora/RHEL**.

## Install

```bash
git clone https://github.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks
cd linux-hibernate-dual-boot-tweaks/tweakctl
sudo cp tweakctl /usr/local/bin/
```

## Usage

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

## How it works
- **Hibernate enable** detects your distro and either adds `resume=UUID=...` to GRUB (Arch/Ubuntu) and rebuilds initramfs (`mkinitcpio -P`/`update-initramfs -u`), or uses `grubby` + `dracut` on Fedora. Always creates the fstab swap line if missing.
- **S3** writes `mem_sleep_default=deep` to the same place your distro stores kernel args.
- **Plymouth** switches theme via `plymouth-set-default-theme` and rebuilds initramfs.
- **Sound** rewrites the systemd user unit to point at the chosen file and reloads it.

## Safety
- Every mutating command first prints what distro it detected.
- It never touches the Windows/NTFS partition.
- Always disable Windows Fast Startup before relying on hibernate on dual-boot.
