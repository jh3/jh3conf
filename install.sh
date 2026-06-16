#!/bin/bash
set -e

# DOTFILES defaults to the dir this script lives in. Override with the
# DOTFILES env var if you keep the repo elsewhere.
DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export DOTFILES
OS="$(uname -s)"

# Non-interactive override knobs:
#   FORCE=1   answer "yes, replace" to every prompt (still backs up)
#   ASSUME_NO=1   answer "no, skip" to every prompt
OVERRIDE_ALL="${FORCE:-0}"
SKIP_ALL="${ASSUME_NO:-0}"

# Ask y/n/a/q. Returns 0 = proceed, 1 = skip, exits on quit.
confirm() {
    local prompt="$1"
    if [ "$OVERRIDE_ALL" = "1" ]; then return 0; fi
    if [ "$SKIP_ALL" = "1" ];      then return 1; fi
    if [ ! -t 0 ]; then
        # No TTY: default to "no" so we never silently clobber.
        echo "  (no TTY — skipping; set FORCE=1 to override)"
        return 1
    fi
    while true; do
        read -r -p "$prompt [y]es / [n]o / [a]ll yes / [q]uit: " ans
        case "$ans" in
            y|Y) return 0 ;;
            n|N|"") return 1 ;;
            a|A) OVERRIDE_ALL=1; return 0 ;;
            q|Q) echo "Aborted."; exit 1 ;;
        esac
    done
}

# safe_link <target> <link_name>
# Always prompts (so nothing gets silently installed). If a real file/dir/
# wrong symlink is in the way, backs it up to ".bak.<timestamp>" first.
safe_link() {
    local target="$1" link="$2"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        return 0
    fi
    local prompt
    if [ -e "$link" ] || [ -L "$link" ]; then
        local kind
        if [ -L "$link" ]; then
            kind="symlink → $(readlink "$link")"
        elif [ -d "$link" ]; then
            kind="directory"
        else
            kind="file"
        fi
        echo "EXISTS: $link ($kind)"
        prompt="  Replace with symlink to $target?"
    else
        echo "LINK:   $link → $target"
        prompt="  Create symlink?"
    fi
    if ! confirm "$prompt"; then
        echo "  skipped."
        return 0
    fi
    if [ -e "$link" ] || [ -L "$link" ]; then
        local backup="${link}.bak.$(date +%Y%m%d%H%M%S)"
        echo "  backing up → $backup"
        mv "$link" "$backup"
    fi
    ln -sfn "$target" "$link"
    echo "  linked $link → $target"
}

# Linux: install missing pacman packages. Detect what's missing first and
# only install those, after asking.
if [ "$OS" = "Linux" ] && [ -r "$DOTFILES/arch/packages" ] && command -v pacman >/dev/null 2>&1; then
    pkgs=$(grep -v '^\s*#' "$DOTFILES/arch/packages" | grep -v '^\s*$')
    missing=()
    for p in $pkgs; do
        pacman -Q "$p" >/dev/null 2>&1 || missing+=("$p")
    done
    if [ ${#missing[@]} -eq 0 ]; then
        echo "All Arch packages already installed."
    else
        echo "Missing Arch packages: ${missing[*]}"
        if confirm "Install ${#missing[@]} package(s) via pacman?"; then
            sudo pacman -S --needed --noconfirm "${missing[@]}"
        else
            echo "  skipped pacman install."
        fi
    fi
fi

mkdir -p "$HOME/.config"

# Cross-platform configs
safe_link "$DOTFILES/nvim"           "$HOME/.config/nvim"
safe_link "$DOTFILES/tmux"           "$HOME/.config/tmux"
safe_link "$DOTFILES/kitty"          "$HOME/.config/kitty"
safe_link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
safe_link "$DOTFILES/git/gitconfig"  "$HOME/.gitconfig"

# Per-machine git identity / tokens / credential helper / safe.directory live here.
# Seed from the example if it doesn't already exist (never overwrite).
if [ ! -e "$HOME/.gitconfig.local" ]; then
    cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
    chmod 600 "$HOME/.gitconfig.local"
    echo "Created $HOME/.gitconfig.local — edit it to set user.name / user.email."
fi

# zsh: install zinit, link ~/.zshrc.
bash "$DOTFILES/zsh/install.sh"

# tmux plugin manager — only set up if the live tmux config references tpm.
# (Skipping tpm avoids installing plugins on machines that use a non-repo
# tmux.conf, e.g. Omarchy's stock config.)
if [ ! -d "$HOME/.tmux/plugins/tpm" ] && \
   grep -qs 'tpm/tpm' "$HOME/.tmux.conf" "$HOME/.config/tmux/tmux.conf" 2>/dev/null; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

# packer.nvim + plugin sync (first run only — afterwards use :PackerSync inside nvim)
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi

# Homebrew packages are NOT installed here — slow and opinionated.
# On macOS, install Homebrew then run:
#     brew bundle --file=$DOTFILES/brew/Brewfile
