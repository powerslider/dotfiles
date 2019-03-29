#!/bin/bash

set -e

# Absolute path to this script, e.g. /Users/pesho/bin/foo.sh
SCRIPT=$(greadlink -f $0)
# Absolute path this script is in. /Users/pesho/bin
SCRIPTPATH=$(dirname $SCRIPT)

# Set MacOS sanity settings
"$SCRIPTPATH/sanity_settings.sh"

# General installation of hidden files
for x in _*; do
    actual_file=${x/_/.}
    symlink_target="$HOME/${actual_file}"

    if [[ -h $HOME/$actual_file ]];then
        echo "Another version for $actual_file was found, skipping"
    else
       #rm ${symlink_target}
       echo "Creating symlink at ${symlink_target} ..."
       ln -sf "$SCRIPTPATH/${x}" "${symlink_target}"
    fi
done

test -h "$HOME/.shell" || ln -sf "$SCRIPTPATH/_shell" "$HOME/.shell"
test -h "$HOME/.vim" || ln -sf "$SCRIPTPATH/vim" "$HOME/.vim"
test -h "$HOME/.vimrc" || ln -sf "$SCRIPTPATH/vim/.vimrc" "$HOME/.vimrc"
test -h "$HOME/bin" || ln -sf "$SCRIPTPATH/bin" "$HOME/bin"

# Install programming fonts
"$SCRIPTPATH/fonts/install.sh"


