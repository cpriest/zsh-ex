##################################################
# Keep this include structure light
#   This include structure is loaded before
#	any script is executed Starts with ~/.zshenv
##################################################

SD="`dirname $0`";

# Over-ride compinit with my own function to pass along -C because
# plugin authors use it without -C (skip security check)
alias compinit='my_compinit';

my_compinit() {
	autoload -Uz compinit;
	\compinit -C "$*";
}

() {	# init-fpath
	setopt LOCAL_OPTIONS NULL_GLOB;
	fpath=($SD/fpath $fpath);
	autoload $SD/fpath/*(:t);

	compinit -u &!; # Initialize the completion system
}
