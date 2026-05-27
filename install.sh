#!/bin/bash
set -e

DOTFILES="$HOME/.jh3_dotfiles"
OS="$(uname -s)"

mkdir -p "$HOME/.config"

# Cross-platform configs
ln -sfn "$DOTFILES/nvim"           "$HOME/.config/nvim"
ln -sfn "$DOTFILES/tmux"           "$HOME/.config/tmux"
ln -sfn "$DOTFILES/kitty"          "$HOME/.config/kitty"
ln -sfn "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$DOTFILES/git/gitconfig"  "$HOME/.gitconfig"

# Linux-only window manager / desktop configs
if [ "$OS" = "Linux" ]; then
    ln -sfn "$DOTFILES/hypr"   "$HOME/.config/hypr"
    ln -sfn "$DOTFILES/i3"     "$HOME/.config/i3"
    ln -sfn "$DOTFILES/waybar" "$HOME/.config/waybar"
    ln -sfn "$DOTFILES/rofi"   "$HOME/.config/rofi"
fi

# Per-machine git identity / tokens / safe.directory entries live here.
# Seed from the example if it doesn't already exist.
if [ ! -e "$HOME/.gitconfig.local" ]; then
    cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
    chmod 600 "$HOME/.gitconfig.local"
    echo "Created $HOME/.gitconfig.local — edit it to set user.name / user.email."
fi

# oh-my-zsh + custom symlinks
bash "$DOTFILES/zsh/install.sh"

# tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
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
# Install Homebrew, then run:
#     brew bundle --file=$DOTFILES/brew/Brewfile
