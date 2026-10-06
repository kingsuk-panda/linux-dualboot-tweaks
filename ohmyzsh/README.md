# Oh My Zsh — Arch / Ubuntu / Fedora

Zsh config with Oh My Zsh, custom theme, and plugins.

## `~/.zshrc` essentials
```bash
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="violet"
plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
```

## Install path
- Arch: `sudo pacman -S zsh`
- Ubuntu: `sudo apt install zsh`
- Fedora: `sudo dnf install zsh`
Then: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

## Custom plugins — `~/.oh-my-zsh/custom/plugins/`
- `zsh-autosuggestions`
- `zsh-history-substring-search`
- `zsh-syntax-highlighting`

## Custom theme — `~/.oh-my-zsh/custom/themes/`
- `violet.zsh-theme`

## Notes
- This is distro-agnostic; same files on Arch/Ubuntu/Fedora/KDE/GNOME.
- Backup note: `~/.zsh_history`, `~/.oh-my-zsh/custom/themes/violet.zsh-theme` are the only custom parts; reinstall Oh My Zsh and drop these files back in to reproduce.

## Bundled files
- `zshrc` → copy to `~/.zshrc`
- `violet.zsh-theme` → `~/.oh-my-zsh/custom/themes/`
- `plugins-backup/zsh-autosuggestions` etc. → `~/.oh-my-zsh/custom/plugins/`
