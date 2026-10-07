#!/bin/bash
set -e
# build .deb, .rpm, and Arch package locally
cd "$(dirname "$0")"
VERSION=0.8.0

# Arch package
makepkg -sfC --noconfirm

# .deb
mkdir -p deb/usr/local/bin deb/usr/share/applications deb/usr/share/icons/hicolor/256x256/apps deb/DEBIAN
cp ../tweakctl deb/usr/local/bin/
cp ../tweakctl-gui deb/usr/local/bin/
chmod 755 deb/usr/local/bin/tweakctl deb/usr/local/bin/tweakctl-gui
cp ../tweakctl-gui.desktop deb/usr/share/applications/
cp ../tweakctl.png deb/usr/share/icons/hicolor/256x256/apps/tweakctl.png
cp deb-control deb/DEBIAN/control
dpkg-deb --build deb tweakctl_${VERSION}_all.deb

# .rpm
mkdir -p rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
cp ../tweakctl rpmbuild/SOURCES/
cp ../tweakctl-gui rpmbuild/SOURCES/
cp ../tweakctl-gui.desktop rpmbuild/SOURCES/tweakctl-gui.desktop
cp ../tweakctl.png rpmbuild/SOURCES/tweakctl.png
cp tweakctl.spec rpmbuild/SPECS/
rpmbuild -bb --define "_topdir $PWD/rpmbuild" rpmbuild/SPECS/tweakctl.spec

echo "Built:"
ls *.pkg.tar.zst *.deb rpmbuild/RPMS/noarch/*.rpm 2>/dev/null
