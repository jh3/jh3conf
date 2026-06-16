#!/bin/bash
set -e

# Resolve the dotfiles root. install.sh exports DOTFILES; if this script is
# run on its own, fall back to its own directory's parent.
DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Make sure zsh itself is installed.
if ! command -v zsh >/dev/null 2>&1; then
    case "$(uname -s)" in
        Linux)
            if command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --needed --noconfirm zsh
            else
                echo "zsh not found and no supported package manager — install zsh manually." >&2
                exit 1
            fi
            ;;
        Darwin)
            command -v brew >/dev/null 2>&1 && brew install zsh
            ;;
    esac
fi

# Install zinit (plugin manager). The first launch of zsh will also self-heal
# this, but doing it here means `install.sh` finishes with everything ready.
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Link ~/.zshrc → repo zshrc, but only if user OKs replacing any existing one.
# Re-uses the safe_link function from the parent install.sh if available;
# otherwise does a minimal version of the same check.
LINK="$HOME/.zshrc"
TARGET="$DOTFILES/zsh/zshrc"
if [ -L "$LINK" ] && [ "$(readlink "$LINK")" = "$TARGET" ]; then
    :
elif [ -e "$LINK" ] || [ -L "$LINK" ]; then
    if [ "${FORCE:-0}" = "1" ]; then
        backup="${LINK}.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up $LINK → $backup"
        mv "$LINK" "$backup"
        ln -sfn "$TARGET" "$LINK"
    else
        echo "EXISTS: $LINK — leaving it alone. Re-run with FORCE=1 to replace."
    fi
else
    ln -sfn "$TARGET" "$LINK"
    echo "linked $LINK → $TARGET"
fi

# Note: switching the login shell to zsh is a one-time, user-visible action.
# It is NOT done automatically — run `chsh -s "$(which zsh)"` yourself.
if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
    echo "Your login shell is $SHELL. Run: chsh -s \"\$(which zsh)\" to switch."
fi
