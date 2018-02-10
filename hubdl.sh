#!/bin/bash

rm dl.list
IFS=$'\n'
for i in $(cat links.db); do
    name=$(curl --silent "$i" \
        | grep '<title>' \
        | sed -e 's/<title>// ; s/<\/title>// ; s/Pornhub.com// ; s/-// ; s/\ $// ; s/^\ //g ; s/^[[:space:]]*// ; s/[[:space:]]*$// ; s/[[:space:]]/_/g')
    echo "'$i'" "'$name.mp4'" >> dl.list
done

IFS=$'\n'
for dl in $(cat dl.list);do
    url=$(echo "$dl" | awk '{print $1}')
    filename=$(echo "$dl" | awk '{print $2}')
    echo wget -O "$filename" "$url"
    while getopts ":xo:" opt;do
        case "$opt" in
            x)
                echo "Executing command!"
                wget -c -O "$filename" "$url"
                ;;
            o)
                echo "Saving command to $OPTARG.sh"
                printf "wget -c -O $filename $url" >> "$OPTARG.sh"
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                ;;
        esac
    done
done

