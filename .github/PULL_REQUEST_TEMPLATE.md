Thanks for the contribution! Please:

- Describe what you changed and why.
- Note how you tested it (distro + desktop + commands run).
- Keep each feature in its own folder with its own README and a
  `setup.sh` (see CONTRIBUTING.md).
- If it touches `tweakctl`/`tweakctl-gui`: run
  `python3 tweakctl-gui --selftest` and paste the result.
- If it changes the version, use `./bump-version.sh <version> --tag`
  — the build fails if the tag and the code disagree.
