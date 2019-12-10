#!/bin/zsh

#
# This file includes helper functions intended to be sourced by other scripts
#

setopt LOCAL_OPTIONS LOCAL_TRAPS;


# Testing to get SF/SD working for both autoloaded functions and scripts
#	Timeboxed out for the moment.
#
# local SFx=${(%):-%x}
# local SFN=${(%):-%N}
# pv SFx
# pv SFN
# pv ZSH_SCRIPT
# pv 0
#
#**** type $0	- This shows the path of an autoloaded function

# Prints out a yelllow warning line of all arguments passed in
warn() { echo "\e[33m$@\e[m"; }
WARN() { echo "\e[33;1m$@\e[m"; }

# Prints out a red error line of all arguments passed in, followed by the help contents
error() {
	echo "\e[31;1m$@\e[m";
	help;
}

# Prints out args $2..$N if verbosity is at least the value of $1
vmsg() {
	[[ $1 > $VERBOSITY ]] &&
		return;
	shift;	# Drop $1
	echo $*;
}

# Capture SF/SD based on ZSH_SCRIPT if not already set
[[ -z "$SF" && -n "$ZSH_SCRIPT" ]] && {
	local SF=${ZSH_SCRIPT:a};
	local SD=${SF:h};
}

# Ends the function call with an exit status of 128 + $1
TRAPABRT() { return $(( 128 + $1 )); }

# Prints out the help for this command, as formatted above with lines that start out with ##<tab>
help() {
	[[ -z "$SF" ]] && {
		WARN "Cannot show help, \$SF is not set to source file of main script (containing help).";
		kill -ABRT $$;
	}
	print -l "`cat $SF | \pcregrep -o1 '^##\t(.+)$'`";
	kill -ABRT $$;
}

# evals $@ after printing the command in magenta, useful for showing commands
# that are being run
run() {
	CMD="$@";
	[[ ${ZEX_RUN_RUNS=0} -gt 0 ]] &&
		echo;
	echo "\e[38;5;201m${CMD//\\}\e[m";
	ZEX_RUN_RUNS=$((${ZEX_RUN_RUNS}+1));
	eval "$CMD";
	return 0;
}
