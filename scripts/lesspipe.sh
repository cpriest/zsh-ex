
#!/bin/sh
#
# To use this filter with less, define LESSOPEN:
# export LESSOPEN="|/usr/bin/lesspipe.sh %s"

# Formats to use (-f) with source-highlight for regular and 256 color
SRC_HL_FMT="esc"
SRC_HL_256FMT="esc256";

# Formats & Option sto use with pygmentize
PYG_STYLE="manni"
PYG_FMT="console";
PYG_FMT256="console256";
PYG_STYLE="native";

shopt -s extglob
FNAME="$1";
DECOMPRESSOR="cat";
VIEWER="source-highlight --failsafe --infer-lang -f esc --style-file=esc.style";
EXT="";


#
#	Initial Exploration
#
EXEC_SRCHL=`which source-highlight 2>/dev/null`;
EXEC_PYG=`which pygmentize 2>/dev/null`;

# eat() - Eats STDOUT/STDERR, basically just gives us exit code
eat() {
	$* 1>/dev/null 2>&1;
}

eat which pcregrep || {
	echo "This utility requires pcregrep" && exit 1;
};

#
#	Check to see if source-highlight is installed and if it can handle the extension
#
check_source_highlight() {
	[[ -x ${EXEC_SRCHL} ]] &&
		${EXEC_SRCHL} --lang-list | eat pcregrep "^${EXT}";
}

#
#	Highlight with source-highlight
#
source_highlight() {
	FMT=${SRC_HL_FMT};
	[[ "${TERM}" == *256* && -e /usr/share/source-highlight/${SRC_HL_256FMT}.outlang ]] && FMT=${SRC_HL_256FMT}
	${EXEC_SRCHL} -f ${FMT} --style-file=${FMT}.style -i ${FNAME} -o STDOUT;
	return 0;
}

#
#	Check to see if python pygments is installed and if it can handle the extension
#
check_pygmentize() {
	[[ -x ${EXEC_PYG} ]] &&
		${EXEC_PYG} -L lexers | grep filenames | pcregrep -o "\*.\w+" | sort | uniq | eat pcregrep "${EXT}"
}

#
#	Highlight with pygmentize
#
pygmentize() {
	FMT=${PYG_FMT};
	[[ "${TERM}" == *256* ]] && FMT=${PYG_FMT256};
	${EXEC_PYG} -f ${FMT} -O style=${PYG_STYLE} ${FNAME}
	return 0;
}

find_decompressor() {
	case "$FNAME" in
		*.@(z|Z|gz))	DECOMPRESSOR="gzip -dc -- ${FNAME}"; 	FNAME="${FNAME%.@(z|Z|gz)}"; ;;
		*.bz2)			DECOMPRESSOR="bzip2 -dc -- ${FNAME}"; 	FNAME="${FNAME%.bz2}"; ;;
		*.@(xz|lzma))	DECOMPRESSOR="xz -dc -- ${FNAME}"; 		FNAME="${FNAME%.@(xz|lzma)}"; ;;

#		*.[1-9n]|*.[1-9]x|*.man|*.[1-9n].bz2|*.[1-9]x.bz2|*.man.bz2|*.[1-9n].[gx]z|*.[1-9]x.[gx]z|*.man.[gx]z|*.[1-9n].lzma|*.[1-9]x.lzma|*.man.lzma)
#			if $DECOMPRESSOR -- "$1" | file - | grep -q troff; then
#				 -- "$1" | groff -Tascii -mandoc -
#			else
#				$DECOMPRESSOR -- "$1"
#			fi
#			;;
	esac;

	[[ "$DECOMPRESSOR" == "cat" ]] && return 0;

	# Convert /x/y/z/blah.php to /tmp/blah.php for mkfifo
	FNAME="/tmp/${FNAME##*/}";
	
	rm -f "${FNAME}";
	trap "rm -f ${FNAME}" EXIT ERR;
	{
		mkfifo ${FNAME} &&
			${DECOMPRESSOR} > ${FNAME};
		rm -f ${FNAME};
	} &

	# Wait briefly for above to start
	sleep .01;
}

find_viewer() {
	case "${FNAME}" in
		*.crt)				openssl x509 -text -noout -in ${FNAME} ;;
		*.csr)				openssl req -in ${FNAME} -text ;;
		*.tar) 				tar tvvf ${FNAME} ;;
		*.tgz)				tar tzvvf "${FNAME}" ;;
		*.zip|*.jar|*.nbm)	zipinfo -- "${FNAME}" ;;
		*.tbz2) 			bzip2 -dc -- "${FNAME}" | tar tvvf -; ;;
		*.rpm)				rpm -qpivl --changelog -- "${FNAME}" ;;
		*.cpi|*.cpio)		cpio -itv < "${FNAME}" ;;
		*.gif|*.jpeg|*.jpg|*.pcd|*.png|*.tga|*.tiff|*.tif)
			if [ -x /usr/bin/identify ]; then
				identify "${FNAME}"
			elif [ -x /usr/bin/gm ]; then
				gm identify "${FNAME}"
			else
				echo "No identify available, Install ImageMagick or GraphicsMagick to browse images";
			fi
			;;
		*)
			EXT="${FNAME##*.}";
			check_source_highlight && {
				source_highlight;
			} || {
				check_pygmentize && {
					pygmentize;
				} || {
					cat ${FNAME};
				}
			}
	esac
}

if [ -d "$1" ] ; then
	pwd; echo; /bin/ls -alF --color -- "$1"
else
	find_decompressor;
	find_viewer;
fi
