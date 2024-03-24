#!/bin/bash

########
# This script sets up symlinks from the home directory (~) to the dotfiles in this repo
# Run ./setup.sh <list of space separated files> or ./setup.sh all
# Or just run ./setup.sh to be prompted for which files you want to symlink 
#   - It also shows which files are not yet linked
########

dir=$(pwd)
backupdir=~/dotfiles_OLD
RED="\033[0;31m"

all_files=($(ls))
exclude_files=("README.md" "setup.sh" "eg-examples" "vim" "macos_shortcuts_setup.md" "iterm_my_light_theme.json" "setup_linux.sh" "setup_zsh.sh" "Brewfile" "Brewfile.lock.json" "setup_tmux.sh")
additional_symlink_dirs_to_include=("vim" "scripts_global")

# Get list of all dotfiles without the excluded files
for f_ind in "${!all_files[@]}"; do
    for ex_file in "${exclude_files[@]}"; do
        if [[ "${all_files[f_ind]}" == "$ex_file" ]]; then
            unset 'all_files[f_ind]'
        fi
    done
done

dotfiles=("${all_files[@]}")

files_to_link=("$@")
dirs_to_link=("${additional_symlink_dirs_to_include[@]}")

# Determine which files are not linked yet 
# Specifically checks if they aren't linked to the dotfiles in this dir since
#   they could be linked to some other files elsewhere
function get_unlinked_files {
    unlinked_files=()
    unlinked_dirs=()
    
    for file in "${dotfiles[@]}"; do

        # If the dotfile is a dir and it's not already created
        if [ -d "$dir/$file" ] && [ ! -d ~/"$dir" ]; then 
            unlinked_dirs+=("${file}")
        # It's a file and the file doesn't exist at all
        elif [ ! -f ~/".${file}" ]; then 
            unlinked_files+=("${file}")    
        # Check if existing file is not symlinked to the dotfile in this dir
        elif [ ! ~/".${file}" -ef "${file}" ]; then
            unlinked_files+=("${file}")
        fi

    done
}

function ask_for_files {
    get_unlinked_files

    echo -e "\n"
    echo "Write a space separated list of all dotfiles you want linked (press Enter without typing anything for all files to be used)"
    echo "OR exit and re-run this script with the 'unlinked_only' or 'all' params to choose automatically"
    echo "Found these possible dotfiles: ${dotfiles[@]}"
    echo "Found these dotfiles that are not linked yet: ${unlinked_files[@]}"
    echo "Found these dotfile dirs that are not linked yet (these will be linked automatically in addition to whichever files you choose): ${unlinked_dirs[@]}" # later can make this not auto link dirs without explicit choice if we want

    read -p "> " -a files_to_link

    if [ "${files_to_link}" == "" ]; then
        files_to_link=("${dotfiles[@]}")
        dirs_to_link=("${unlinked_dirs[@]}")
    fi
}

function print_gitconfig_info {
    gitconfig_linked="${1}"

    if [ "${gitconfig_linked}" = true ]; then
        if [ ! -f "${HOME}/.gitconfig.private" ]; then
            touch "${HOME}/.gitconfig.private"
        fi
        echo -e "** Set up your git info - we created a ~/.gitconfig.private file - open it and add the following:"

        printf "%s\n" \
            "[user]" \
            "   name = <name>" \
            "   email = <email>" 
    fi
}

# If no args given, then ask user what files they want to sync
if [ "$#" -eq 0 ]; then 
    ask_for_files
# If "unlinked_only" is given, then link only the unlinked ones
elif [[ "$#" == 1 && "$1" == "unlinked_only" ]]; then 
    if [[ -f "./unlinked_only" ]]; then
        echo -e "${RED}Can't use the _unlinked_only_ argument and have a dotfile named _unlinked_only_"
        exit
    fi
    get_unlinked_files
    files_to_link=("${unlinked_files[@]}")
    dirs_to_link=("${unlinked_dirs[@]}")
# If "all" is given, then use all files
elif [[ "$#" == 1 && "$1" == "all" ]]; then 
    if [[ -f "./all" ]]; then
        echo -e "${RED}Can't use the _all_ argument and have a dotfile named _all_"
        exit
    fi
    files_to_link=("${dotfiles[@]}")
fi

# Confirm these files
echo "These dotfiles will be linked: ${files_to_link[@]}"
echo "These dotfile dirs will be linked: ${dirs_to_link[@]}"
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

    if [ "${file}" == "gitconfig" ]; then
        gitconfig_linked=true
    fi
done

# Choose which dotfiles you want to link
echo "Creating backup directory $backupdir to store any already existing dotfiles"
mkdir "$backupdir"

echo ""
# Performing the copying and symlinking
for file in "${files_to_link[@]}"; do
    # Skip any dirs
    if [[ ! -d "./${file}" ]]; then
        continue
    fi

    if [[ -f ~/.$file ]]; then
        echo "!Moving existing dotfile to backup dir: ~/.$file"
        mv ~/.$file $backupdir/$file
    fi

    echo "-Symlinking $file"
    ln -s $dir/$file ~/.$file
done

# Also auto links all the files in the additional_symlink_dirs_to_include
# NOTE: we assume that the dir itself is a hidden .dir but the files inside are not hidden (don't have a dot prefix)
for add_dir in "${dirs_to_link[@]}"; do

    # create if not exists
    if [ ! -d ".$add_dir" ]; then
        echo "Creating dir ~/.$add_dir"
        mkdir ~/".$add_dir"
    fi

    for file_with_dir in "${add_dir}/"*; do
        if [[ -f ~/.$file_with_dir ]]; then
            echo "!Moving existing dotfile to backup dir: ~/.$file_with_dir"
            mv ~/.$file_with_dir $backupdir/$file_with_dir
        fi

        echo "-Symlinking ~/.$file_with_dir"
        ln -s $dir/$file_with_dir ~/.$file_with_dir
    done
done

echo -e "\nFinished linking everything!\n"

# if [ ! -f "${HOME}/.vim/autoload/plug.vim" ]; then
#     echo "Installing Vim Plug"
#     curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ 
#         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# fi
# echo "Installing vim plugins"
# vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"

echo -e "\nInstalling eg"
{
    pip install eg
} || {
    echo "-- 'pip install eg' failed, please try re-running it yourself"
}

echo -e "\n\n"
echo "** Remember to source your ~/.bashrc"
print_gitconfig_info "${gitconfig_linked}"
echo "See additional useful files: macos_shortcuts_setup.md"
echo "Install node manually by installing nvm first via their script from https://github.com/nvm-sh/nvm#installing-and-updating and then do 'nvm install node' and 'npm install -g yarn'"
echo "Install my common utilities with 'brew bundle' to install the packages in 'brewfile'"
echo "Install any ohmyzsh plugins with ./setup_zsh.sh"
echo "Install tmux plugins with ./setup_tmux.sh"
