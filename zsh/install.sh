#!/bin/bash

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ln -s $HOME/dotfiles/zsh $HOME/.oh-my-zsh/custom
