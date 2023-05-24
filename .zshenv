##################################################
# Keep this include structure light
#   This include structure is loaded before
#	any script is executed Starts with ~/.zshenv
##################################################

() {
	# Source directory of current script
	local SD=${${(%):-%x}:h};

	export ZSH_DISABLE_COMPFIX=true;

	ZEX_DIR=$SD;

	# Over-ride compinit with my own function to pass along -C because
	# plugin authors use it without -C (skip security check)
	alias compinit='my_compinit';

	my_compinit() {
		# echo "\e[31;1mcalled my_compinit $*\e[m";

		# Over-ridden to add -u to the compinit call (to ignore security issues)
		# Note: calling compinit ourselves too early causes problems, just letting
		# antigen setup call compinit now.
		\compinit -u "$*";
	}

	# init-fpath
	setopt LOCAL_OPTIONS NULL_GLOB;

	fpath=($SD/fpath $fpath);
	autoload $SD/fpath/*(:t);

	autoload -Uz compinit;
}
