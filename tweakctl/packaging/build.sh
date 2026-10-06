#!/bin/bash
set -e
# build .deb, .rpm, and Arch package locally
cd "$(dirname "$0")"
VERSION=0.2.2

# Arch package
makepkg -sfC --noconfirm

# .deb
mkdir -p deb/usr/local/bin deb/DEBIAN
cp ../tweakctl deb/usr/local/bin/
chmod 755 deb/usr/local/bin/tweakctl
cp deb-control deb/DEBIAN/control
dpkg-deb --build deb tweakctl_${VERSION}_all.deb

# .rpm
mkdir -p rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
cp ../tweakctl rpmbuild/SOURCES/
cp tweakctl.spec rpmbuild/SPECS/
rpmbuild -bb --define "_topdir $PWD/rpmbuild" rpmbuild/SPECS/tweakctl.spec

echo "Built:"
ls *.pkg.tar.zst *.deb rpmbuild/RPMS/noarch/*.rpm 2>/dev/null
