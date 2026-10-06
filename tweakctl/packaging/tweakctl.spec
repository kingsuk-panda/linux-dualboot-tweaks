Name:           tweakctl
Version:        0.7.0
Release:        1%{?dist}
Summary:        Hibernation/S3/Plymouth/ctOS tuner CLI+GUI for Arch, Ubuntu, Fedora
License:        MIT
URL:            https://github.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks
Source0:        tweakctl
Source1:        tweakctl-gui
BuildArch:      noarch
Requires:       python3, python3-tkinter

%description
One CLI and GUI to check and enable hibernation, toggle S3 deep sleep,
select Plymouth themes, and apply ctOS sounds.

%install
install -Dm755 %{SOURCE0} %{buildroot}/usr/local/bin/tweakctl
install -Dm755 %{SOURCE1} %{buildroot}/usr/local/bin/tweakctl-gui
install -Dm644 %{SOURCE1}.desktop %{buildroot}/usr/share/applications/tweakctl-gui.desktop

%files
/usr/local/bin/tweakctl
/usr/local/bin/tweakctl-gui
/usr/share/applications/tweakctl-gui.desktop
