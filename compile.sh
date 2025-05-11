#!/bin/sh
{
	while IFS= read -r l; do
		case "$l" in
		'#include <'*'.tal>')
			l="${l#'#include <'}"
			l="${l%'>'}"
			tals="$tals $l"
			;;
		*) echo "$l" ;;
		esac
	done < "$1" > tmp1.c
	cc -I. -I"${0%/*}" -P -E -x c tmp1.c -o tmp2.c && chibicc-uxn -O tmp2.c

	for f in $tals; do
		# sed 's/^@[^ ]*/&_\n&/' < "$f"
		cat "$f"
	done
} | {
	bss=
	while IFS= read -r l; do
		case "$l" in
		'( bss )')
			while
				case "$l" in
				'( data )') break ;;
				esac
				bss="$bss"$'\n'"$l"
				IFS= read -r l;
			do :; done
			;;
		esac
		echo "$l"
	done
	echo "$bss"
}
