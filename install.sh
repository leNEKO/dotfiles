#!/usr/bin/env bash

# working dir
export DIR
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
function bash_cfg(){
    for f in $(fd . -t f bash); do
        in="$DIR/$f"
        out=$(echo ~/.${f##*/})
        ln -sfv $in $out
    done
}

# vscode
function vscode_cfg(){
    # config files
    VS_DIR=$(echo ~/.config/Code)
    VS_DATA="vscode/data"
    for f in $(fd . -t f $VS_DATA); do
        in=$DIR/$f
        out=$VS_DIR/${f/$VS_DATA\/}
        ln -sfv $in $out
    done
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

bash_cfg
vscode_cfg
vscode_ext
exit 0