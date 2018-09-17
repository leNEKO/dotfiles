#!/usr/bin/env bash

# working dir
export DIR
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
function install_bash(){
    for f in $(fd . bash); do
        in="$DIR/$f"
        out="~/.${f##*/}"
        ln -sfv "$in $out"
    done
}

# vscode
function install_vscode(){
    export VS_DIR
    VS_DIR="~/.config/Code"
    for f in $(fd . vscode); do
        in="$DIR/$f"
        out="$VS_DIR/${f##*/}"
        echo "ln -sfv "$in $out""
    done
}

install_vscode