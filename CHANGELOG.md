# Changelog

All notable changes to tweakctl. This file drives the release notes: the
build workflow copies the section matching the tag into the GitHub release
description automatically (and fails the build if a section is missing).

## [0.8.0] — 2026-10-07
### Added
- Real app identity: custom logo (rounded square, green accent), installed
  to `/usr/share/icons/hicolor/256x256/apps/tweakctl.png` by every
  package, bundled in the AppImage, and embedded in the GUI so the window
  icon shows on every install method
- Desktop entry now uses `Icon=tweakctl` — the app appears in the menu
  with its own icon, not a generic gear
- Animated ANSI logo + color sweep when the TUI starts (skippable,
  pipe-safe: only shows in the interactive menu)
- Modern TUI: header bar with logo + version, sectioned menu with glyphs
  (❄ ☾ ◐ ♪ ⚙), colored status pills, footer with key hints
- GUI redesigned: dark modern theme, rounded custom widgets with hover
  and press feedback, icon sidebar, card layout, status pills, toast
  notifications, scrollable pages, pulsing busy indicator
- `bump-version.sh` — single source of truth: updates the version in both
  apps, package.json, PKGBUILD, spec, deb-control and build.sh, then tags
- Issue templates (bug report, feature request) and a PR template
- Toasts confirm completed actions ("Hibernation set up — reboot...")

### Changed
- GUI is a full visual overhaul (still tkinter — zero dependencies,
  fast, AppImage stays small); pages now scroll on small windows
- `tweakctl gui` now works for npm users (the package ships
  `tweakctl-gui` too) and falls back to `python3 tweakctl-gui` when the
  exec bit is missing

### Fixed
- Releases now have proper descriptions (generated from this changelog)
- Stale build artifacts (`tweakctl/deb/`) removed from the repo
- `package.json` version kept in sync
- Workflow fails fast if the tag version doesn't match the app version

## [0.7.4] — 2026-10-06
### Added
- Plymouth preview plays the theme's animation **inside the app**
  (pure-Python GIF decoder: LZW, interlacing, GCE disposal, local and
  global palettes — no PIL needed)
- Preview window: plays at the GIF's real frame rate, loops, ESC or
  Close stops it

### Fixed
- GIF LZW code-size increase used `>` instead of `>=`, truncating frames
- GUI binary bundles `urllib.request` and `json` as hidden imports

## [0.7.3] — 2026-10-06
### Added
- Zero-dependency **AppImage** (PyInstaller onefile + appimagetool) —
  bundles python3 + tkinter, runs on any distro
- GUI is frozen-aware: imports state functions from the bundled
  tweakctl script, mutations run the compiled binary

## [0.7.0] — 2026-10-05
### Added
- `tweakctl-gui` — tkinter graphical front-end: sidebar pages (Dashboard,
  Hibernation, S3, Boot splash, Sounds, Updates, About), pickers,
  confirm dialogs, shared disclaimer, live log, pkexec/sudo elevation
- ESC closes the Plymouth preview; refined fonts and colors

## [0.6.0] — 2026-10-04
### Changed
- Plain-English wording pass, first-run disclaimer screen, automatic
  Windows dual-boot warning, word-wrapped output, instant Esc

## [0.5.0] — 2026-10-03
### Added
- Modal list pickers (↑/↓/Enter, letter jump, Home/End, vim keys)
- Temporary theme switch for preview with automatic restore
- Error hardening (missing GRUB, sed escaping)
