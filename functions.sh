v() {
	[ $VERBOSE -eq 1 ] && echo "$1"
}

append() {
	local var="$1"
	local value="$2"
	local sep="${3:- }"

	eval "export \"$var=\${$var:+\${$var}\${value:+\$sep}}\$value\""
}

include() {
	local files file
	if [ -d $1 ]; then
		files=$(find $1 -name "*.sh" -type f)
		for file in $files; do
			. ${file}
		done
	elif [ -f $1 ]; then
		. $1
	fi
}

check_utils() {
	local utils="wget screen"

	for util in $utils; do
		type $util 2>/dev/null 1>&2 || {
			v "$util is not installed"
			exit 1
		}
	done
}

check_deps() {
	local deps=""
	# TODO
}
