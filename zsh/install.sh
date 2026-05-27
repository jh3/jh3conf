#!/bin/bash
set -e

# install oh-my-zsh if missing (its installer otherwise refuses to run)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# oh-my-zsh auto-sources $ZSH_CUSTOM/*.zsh, so symlink each .zsh file
# individually rather than the whole zsh/ dir.
for f in "$HOME/.jh3_dotfiles/zsh/"*.zsh; do
    [ -e "$f" ] || continue
    ln -sfn "$f" "$HOME/.oh-my-zsh/custom/$(basename "$f")"
done
