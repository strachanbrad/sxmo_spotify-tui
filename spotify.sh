#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors
# title="$icon_dir Spotify"
# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

#set -e

PICKED=
ARGS=

menu() {
	while true; do
		CHOICES="$(printf %b "Close Menu\nPlaylist Search\nSong Search\nArtist Search\nAlbum Search")"

		PICKED="$(
			printf %b "$CHOICES" |
			sxmo_dmenu.sh -p "$PICKED" -i
		)"
		
		if [ -n "$PICKED" ]; then
			case "$PICKED" in
				"Close Menu")
					exit 0
					;;
				"Song Search")
					ARGS="--tracks"
					searchmenu
					;;
			esac		
		fi
	done
}

searchmenu() {
	LIST=
	URI=
	while true; do
		ENTRY="$(
				printf %b "
					Close Menu
					Return
					$(printf %s "$LIST" | awk -F "^" '{print $1}')
				" |
					xargs -0 echo |
					sed '/^[[:space:]]*$/d' |
					awk '{$1=$1};1' |
					sxmo_dmenu_with_kb.sh -p "Search"
		)" || exit 0

		case "$ENTRY" in
			"Close Menu")
				exit 0
				;;
			"Return")
				return
				;;
		esac

		URI=$(printf %s "$LIST" | grep "$ENTRY" | awk -F "^" '{print $2}')
		if [ "$URI" != "" ]; then
			echo "$URI"	
		else
			echo "$URI"
			LIST=$(spt search "$ENTRY" "$ARGS" --format "%t by %a ^%u" --limit 10)			
		fi
	done
}

if [ -n "$1" ]; then
	"$@"
else
	menu
fi
