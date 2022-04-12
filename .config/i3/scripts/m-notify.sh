#!/usr/bin/env bash

title="$(playerctl metadata title)"
artist="$(playerctl metadata artist)"
icon="$(playerctl metadata mpris:artUrl)"

if [ ! -z "$title" || ! -z "$artist" ]
then
	dunstify "$title" "$artist" -i "$icon"
fi
