#!/bin/zsh

local SD="`dirname $0`";

init_config() {
	[[ ! -d ~/.config || ! -d ~/.config/zsh-ex ]] && {
		mkdir -p ~/.config/zsh-ex;
		echo "\e[32;1mInstalling default zsh-ex config files defaults to ~/.config/zsh-ex/\e[m";
		\cp -nv $SD/defaults/* ~/.config/zsh-ex/;
	}
}

init_config;

PATH="$SD/bin:$PATH";
