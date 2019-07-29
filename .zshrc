#!/bin/zsh

() {
	# Source directory of current script
	local SD=${${(%):-%x}:h};

	ZEX_DIR=$SD;

	init_config() {
		[[ ! -d ~/.config || ! -d ~/.config/zsh-ex ]] && {
			mkdir -p ~/.config/zsh-ex;
		}

		INSTALLED=();
		for file in `\ls -1 $SD/defaults/*`; {
			[[ ! -e ~/.config/zsh-ex/${file:t} ]] && {
				\cp -n "$file" ~/.config/zsh-ex/;
				INSTALLED+=( "${(b)file:t}" );
			}
		}
		[[ ${#INSTALLED} > 0 ]] && {
			echo "\e[32;1mInstalled default zsh-ex config files to ~/.config/zsh-ex/\e[m";
			for file in ${INSTALLED[@]}; {
				echo "    $file";
			}
		}
	}
	init_config;

	PATH="$SD/bin:$PATH";

	source $SD/inc/*.zsh;
}

