Name:           tweakctl
Version:        0.8.0
Release:        1%{?dist}
Summary:        Hibernation/S3/Plymouth/ctOS tuner CLI+GUI for Arch, Ubuntu, Fedora
License:        MIT
URL:            https://github.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks
Source0:        tweakctl
Source1:        tweakctl-gui
Source2:        tweakctl.png
BuildArch:      noarch
Requires:       python3, python3-tkinter

%description
One CLI and GUI to check and enable hibernation, toggle S3 deep sleep,
select Plymouth themes, and apply ctOS sounds.

%install
install -Dm755 %{SOURCE0} %{buildroot}/usr/local/bin/tweakctl
install -Dm755 %{SOURCE1} %{buildroot}/usr/local/bin/tweakctl-gui
install -Dm644 %{SOURCE1}.desktop %{buildroot}/usr/share/applications/tweakctl-gui.desktop
install -Dm644 %{SOURCE2} %{buildroot}/usr/share/icons/hicolor/256x256/apps/tweakctl.png

%files
/usr/local/bin/tweakctl
/usr/local/bin/tweakctl-gui
/usr/share/applications/tweakctl-gui.desktop
/usr/share/icons/hicolor/256x256/apps/tweakctl.png
