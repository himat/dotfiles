#!/bin/bash

########
# This script sets up symlinks from the home directory (~) to the dotfiles in this repo
# Run ./setup.sh <list of space separated files> or ./setup.sh all
# Or just run ./setup.sh to be prompted for which files you want to symlink
########

dir=$(pwd)
backupdir=~/dotfiles_OLD
RED="\033[0;31m"

all_files=($(ls))
exclude_files=("README.md" "setup.sh")

# Get list of all dotfiles without the excluded files
for f_ind in "${!all_files[@]}"; do
    for ex_file in "${exclude_files[@]}"; do
        if [[ "${all_files[f_ind]}" == "$ex_file" ]]; then
            unset 'all_files[f_ind]'
        fi
    done
done

dotfiles="${all_files[@]}"

files_to_link=("$@")

function ask_for_files {
    echo -e "\n"
    echo "Write a space separated list of all dotfiles you want linked (press Enter with an empty line for all files to be used)"
    echo "Found these possible dotfiles: ${dotfiles[@]}"

    read -p "> " -a files_to_link

    if [ "${files_to_link}" == "" ]; then
        files_to_link="${dotfiles[@]}"
    fi
}

# If no args given, then ask user what files they want to sync
if [ "$#" -eq 0 ]; then 
    ask_for_files
# If "all" is given, then use all files
elif [[ "$#" == 1 && "$1" == "all" ]]; then 
    if [[ -f "./all" ]]; then
        echo -e "${RED}Can't use the _all_ argument and have a dotfile named _all_"
        exit
    fi
    files_to_link="${dotfiles[@]}"
fi

# Confirm these files
echo "These dotfiles will be linked: ${files_to_link[@]}"
read -p "Confirm (enter y): " choice 
if [ "${choice}" != "y" ]; then
    echo -e "\n${RED}CANCELLING\n"
    exit
fi

# Check to make sure all passed in files exist
for file in "${files_to_link[@]}"
do
    if [ ! -f "./${file}" ]; then
        echo -e "\n${RED}ERROR: ${file} not found in dotfiles, exiting"
        exit
    fi

    for ex_file in "${exclude_files}"
    do
        if [ "${file}" == "${ex_file}" ]; then
            echo -e "\n${RED}ERROR: ${file} is an excluded file"
        fi
    done
done

exit 


# Choose which dotfiles you want to link
echo "Creating backup directory $backupdir to store any existing dotfiles in ~"
mkdir "$backupdir"

# Performing the copying and symlinking
for file in $files; do
    if [[ -f ~/.$file ]]; then
        echo "Moving existing dotfile $file"
        mv ~/.$file $backupdir/$file
    fi

    echo "Symlinking $file"
    ln -s $dir/$file ~/.$file
done

echo "Finished linking everything!"

echo "Installing vim plugins"
vim +PluginInstall +qall

echo "Remember to source your ~/.bashrc and :PluginInstall if you haven't installed Vundle yet"
