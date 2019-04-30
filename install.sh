#!/usr/bin/env bash
#set -e

# working dir
export DIR
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# cli tools
function tools_cfg(){
    sudo apt-get install -y vim curl
}

# bash
function bash_cfg(){
    for f in $(find bash -type f -not -path '*/\.*'); do
        in="$DIR/$f"
        out=$(echo ~/.${f##*/})
        ln -sfv $in $out
    done
}

# vim
function vim_cfg(){
    # Install vim plugins
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +'PlugInstall --sync' +qa
}

# vscode
function vscode_cfg(){
    # config files
    VS_DIR=$(echo ~/.config/Code)
    VS_DATA="vscode/data"
    for f in $(find $VS_DATA -type f -not -path '*/\.*'); do
        in=$DIR/$f
        out=$VS_DIR/${f/$VS_DATA\/}
        ln -sfv $in $out
    done

    vscode_ext
}

function vscode_ext(){
    # extensions
    VS_EXT="vscode/extensions"

    diff $VS_EXT <(code --list-extensions) |\
    while read c; do
        mode=${c:0:1}
        ext=${c:2}

        # install
        if [[ $mode == '<' ]]; then
            code --install-extension $ext
        # uninstall
        elif [[ $mode == '>' ]]; then
            code --uninstall-extension $ext
        fi
    done
}

function composer_install(){
    EXPECTED_SIGNATURE="$(curl  https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php

        exit 1
    fi

    php composer-setup.php --install-dir="$HOME/bin" --filename=composer

    RESULT=$?
    rm composer-setup.php
    
    return $RESULT
}

function composer_require(){
    composer global require "squizlabs/php_codesniffer=*"
    composer global require "phpmd/phpmd"
}

function main(){
    hash apt-get 2>&1 && tools_cfg
    bash_cfg
    vim_cfg
    hash code 2>&1 && vscode_cfg
    hash php 2>&1 && composer_install
    hash composer 2>&1 && composer_require

    exit 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
