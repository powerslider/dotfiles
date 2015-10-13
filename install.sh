#!/bin/bash
# vim: set sw=4 sts=4 et foldmethod=indent :

#General installation of hidden files
for x in _*;do
    if [ "$x" = "_fonts.conf" ];then
        continue
    fi
    actual_file=${x/_/.}
    symlink_target=$HOME/"${actual_file}"
    
    if [[ -h $HOME/$actual_file ]];then
        echo "Another version for $actual_file was found, skipping"
    else
       #rm ${symlink_target}
       echo "Creating symlink at ${symlink_target} ..."
       ln -sf $PWD/"${x}" "${symlink_target}"
    fi
done

mkdir -p $HOME/.config/fontconfig
test -h $HOME/.config/fontconfig/fonts.conf || ln -sf $PWD/_fonts.conf $HOME/.config/fontconfig/fonts.conf
test -h $HOME/.config/awesome || ln -sf $PWD/awesome $HOME/.config/awesome
test -h $HOME/.config/compton.conf || ln -sf $PWD/_compton.conf $HOME/.config/compton.conf
test -h $HOME/.config/beets/config.yaml || ln -sf $PWD/_beet_config.yaml $HOME/.config/beets/config.yaml

test -h $HOME/.shell || ln -sf $PWD/_shell $HOME/.shell

test -h $HOME/.vim || ln -sf $PWD/vim $HOME/.vim
test -h $HOME/.vimrc || ln -sf $PWD/vim/.vimrc $HOME/.vimrc
test -h $HOME/bin || ln -sf $PWD/bin $HOME/bin

git submodule sync
git submodule init
git submodule update
git submodule foreach git pull origin master
