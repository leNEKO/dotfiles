#!/usr/bin/env bash

# working dir
export DIR
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bash
for in in bash/*; do
    out=~/.${in##*/}
    ln -sfv "$DIR/$in" "$out"
done