#!/usr/bin/env bash
# bump-version.sh — the single source of truth for tweakctl's version.
#
#   ./bump-version.sh 0.8.0          # update every file
#   ./bump-version.sh 0.8.0 --tag    # also commit + tag (needs clean tree)
#
# Updates: tweakctl, tweakctl-gui, package.json, PKGBUILD, tweakctl.spec,
# deb-control, build.sh. The GitHub workflow derives the release version
# from the tag and FAILS if the tag doesn't match these files.
set -euo pipefail

cd "$(dirname "$0")"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <new-version> [--tag]" >&2
  echo "  e.g. $0 0.8.0 --tag" >&2
  exit 2
fi

NEW="$1"
TAG="${2:-}"
case "$NEW" in
  v*) NEW="${NEW#v}" ;;
esac
if ! [[ "$NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Version must be semver (e.g. 0.8.0), got: $NEW" >&2
  exit 2
fi

OLD="$(grep -oP 'VERSION = "\K[^"]+' tweakctl/tweakctl)"
echo "bump: $OLD -> $NEW"

# the two apps
sed -i "s/^VERSION = \".*\"/VERSION = \"$NEW\"/" tweakctl/tweakctl tweakctl/tweakctl-gui
# npm package
sed -i "s/\"version\": \".*\"/\"version\": \"$NEW\"/" tweakctl/package.json
# Arch PKGBUILD (pkgver= and the raw URLs that embed the version)
sed -i "s/^pkgver=.*/pkgver=$NEW/; s|v[0-9][0-9.]*/tweakctl/|v$NEW/tweakctl/|g" tweakctl/packaging/PKGBUILD
# RPM spec
sed -i "s/^Version:        .*/Version:        $NEW/" tweakctl/packaging/tweakctl.spec
# Debian control
sed -i "s/^Version: .*/Version: $NEW/" tweakctl/packaging/deb-control
# local build helper
sed -i "s/^VERSION=.*/VERSION=$NEW/" tweakctl/packaging/build.sh

echo "updated: tweakctl, tweakctl-gui, package.json, PKGBUILD, spec, deb-control, build.sh"

if [ "$TAG" = "--tag" ]; then
  if [ -n "$(git status --porcelain)" ]; then
    echo "Working tree is dirty — commit first, then re-run with --tag." >&2
    exit 1
  fi
  git add -A
  git commit -m "v$NEW" >/dev/null
  git tag -f "v$NEW"
  echo "committed and tagged v$NEW (push with: git push origin main && git push origin v$NEW)"
fi
