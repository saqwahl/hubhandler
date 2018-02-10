#!/bin/bash


# IFS=$'\n'
# for i in $(cat links.db); do
#     shopt -s extglob
#     name=$(curl --silent "$i" \
#         | grep '<title>' \
#         | sed -e 's/<title>// ; s/<\/title>// ; s/Pornhub.com// ; s/-// ; s/\ $// ; s/^\ //g' \
#         | tr -d '[:space:]')
#     shopt -u extglob
#     echo "$i" "'$name'"
# done

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
done
