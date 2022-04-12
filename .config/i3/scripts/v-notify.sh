#!/usr/bin/env bash


players="$(playerctl -l)"
if [ ! -z $players ] 
then
        title="$(playerctl metadata title)"
        artist="$(playerctl metadata artist)"
        icon="$(playerctl metadata mpris:artUrl)"

        if [ ! -z "$title" || ! -z "$artist" ]
        then
                dunstify "$title" "$artist" -i "$icon"
        fi
fi

#icon=""
volume="$(amixer -c 1 -M -D pulse get Master | grep -m1 -o -E [[:digit:]]+%
)"

#dunstify "vol:" -h int:value:"$volume" -i "$icon"
dunstify "vol:" -h int:value:"$volume"

