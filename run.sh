#!/bin/sh

: "${emu:=uxnemu}"

case "$1" in
'--cli')	emu=uxncli; shift ;;
esac

f="$1"
o="${f%.*}"
shift

(exec >&2; "${0%/*}"/compile.sh "$f" > "$o".tal && uxnasm "$o".tal "$o".rom) && $emu "$@" "$o".rom
