#!/bin/bash

########
# This script sets up symlinks from the home directory (~) to the dotfiles in this repo
########

dir=$(pwd)
backupdir=~/dotfiles_OLD

# Choose which dotfiles you want to link
# TODO: Add cmd line required arg which is either "all" or list of dotfiles to setup
# TODO: add check to make sure that there is no dotfile in this repo called "all"
files="bashrc vimrc tmux.conf inputrc gitconfig gitignore_global" 

echo "Creating backup directory $backupdir to store any existing dotfiles in ~"
mkdir "$backupdir"


for file in $files; do
    if [[ -f ~/.$file ]]; then
	echo "Moving existing dotfile"
	mv ~/.$file $backupdir/$file
    fi

    echo "Symlinking $file"
    ln -s $dir/$file ~/.$file
done

echo "Finished linking everything!"

echo "Installing vim plugins"
vim +PluginInstall +qall

echo "Remember to source your ~/.bashrc and :PluginInstall after installing Vundle"
