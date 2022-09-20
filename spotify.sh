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
	ENTRY="$(
			printf %b "
				Close Menu
			" |
				xargs -0 echo |
				sed '/^[[:space:]]*$/d' |
				awk '{$1=$1};1' |
				sxmo_dmenu_with_kb.sh -p "Search"
	)" || exit 0

	if [ "Close Menu" = "$ENTRY" ]; then
		exit 0
	else
		echo "search" "$ENTRY" "$ARGS" "--format \"%t by %a\" --limit 30" | xargs spt
	fi
}

if [ -n "$1" ]; then
	"$@"
else
	menu
fi
