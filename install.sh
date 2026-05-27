#!/bin/bash

ln -s $HOME/.jh3_dotfiles/hypr $HOME/.config/hypr
ln -s $HOME/.jh3_dotfiles/i3 $HOME/.config/i3
ln -s $HOME/.jh3_dotfiles/nvim $HOME/.config/nvim
ln -s $HOME/.jh3_dotfiles/git/gitconfig $HOME/.gitconfig

# Per-machine git identity / tokens / safe.directory entries live here.
# Seed from the example if it doesn't already exist.
if [ ! -e "$HOME/.gitconfig.local" ]; then
    cp $HOME/.jh3_dotfiles/git/gitconfig.local.example $HOME/.gitconfig.local
    chmod 600 $HOME/.gitconfig.local
    echo "Created $HOME/.gitconfig.local — edit it to set user.name / user.email."
fi

ln -s $HOME/.jh3_dotfiles/tmux $HOME/.config/tmux
ln -s $HOME/.jh3_dotfiles/tmux/tmux.conf $HOME/.tmux.conf

# install oh-my-zsh
#ln -s $HOME/dotfiles/zsh $HOME/.oh-my-zsh/custom
