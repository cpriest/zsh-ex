#!/bin/zsh

() {
	# Source directory of current script
	local SD=${${(%):-%x}:h};

	export ZEX_DIR=$SD;

	. ~/.config/zsh-ex/env.zshrc;

	init_config() {
		[[ ! -d ~/.config || ! -d ~/.config/zsh-ex ]] && {
			mkdir -p ~/.config/zsh-ex{,/upscalers};
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

	include $SD/inc/*.zsh;
}

