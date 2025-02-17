#!/bin/bash

ln -s $HOME/dotfiles/hypr $HOME/.config/hypr
ln -s $HOME/dotfiles/i3 $HOME/.config/i3
ln -s $HOME/dotfiles/nvim $HOME/.config/nvim

ln -s $HOME/dotfiles/tmux $HOME/.config/tmux
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ln -s $HOME/dotfiles/zsh $HOME/.oh-my-zsh/custom
