#!/bin/sh

read -r -d '' deps << EOM
dunst
eww-wayland-git socat
qt5-styleplugins
tela-icon-theme-bin
orchis-theme
hyprland-git swaybg slurp grim wl-clipboard xdg-desktop-portal-hyprland-git

neovim
python-pynvim
ripgrep

ttf-roboto-mono-nerd
ttf-material-design-icons-git 

python-rofi-git peerflix
polkit-kde-agent

python python-pip python-babel python-pygments colorpicker
EOM

set -x

paru --sudoloop -S $deps


#libnotify bspwm hsetroot 
#copyq
# oreo-cursors-git
#nodejs
#npm
#the_silver_searcher
#xclip
#picom-git
#polybar terminus-font 
# python-dbus python-gobject 
#sxhkd qutebrowser
