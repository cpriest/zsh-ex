##################################################
# Keep this include structure light
#   This include structure is loaded before
#	any script is executed Starts with ~/.zshenv
##################################################

SD="`dirname $0`";

() {	# init-fpath
	setopt LOCAL_OPTIONS NULL_GLOB;
	fpath=($SD/fpath $fpath);
	autoload $SD/fpath/*(:t);
}
