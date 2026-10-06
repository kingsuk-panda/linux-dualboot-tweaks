Name:           tweakctl
Version:        0.2.0
Release:        1%{?dist}
Summary:        Hibernation/S3/Plymouth/ctOS tuner CLI for Arch, Ubuntu, Fedora
License:        MIT
URL:            https://github.com/kingsuk-panda/linux-hibernate-dual-boot-tweaks
Source0:        tweakctl
BuildArch:      noarch
Requires:       python3

%description
One CLI to check and enable hibernation, toggle S3 deep sleep,
select Plymouth themes, and apply ctOS sounds.

%install
install -Dm755 %{SOURCE0} %{buildroot}/usr/local/bin/tweakctl

%files
/usr/local/bin/tweakctl
