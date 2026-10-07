#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

DIR="$1"
MAL_DIR="$2"

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR is not a directory"
    exit 1
fi

if [ ! -d "$MAL_DIR" ]; then
    echo "Error: $MAL_DIR is not a directory"
    exit 1
fi

while true
do
    files=("$MAL_DIR"/*)

    if [ ! -e "${files[0]}" ]; then
        echo "No malicious files to review."
        exit 0
    fi

    echo "Malicious files:"
    i=1

    for file in "${files[@]}"
    do
        echo "$i. $(basename "$file")"
        i=$((i+1))
    done

    echo "0. Exit"
    read -p "Select a file: " choice

    if [ "$choice" -eq 0 ]; then
        exit 0
    fi

    selected="${files[$((choice-1))]}"

    if [ ! -f "$selected" ]; then
        echo "Invalid selection."
        continue
    fi

    echo "1. Restore"
    echo "2. Delete"
    echo "3. Leave"
    read -p "Choose an action: " action

    case "$action" in
        1)
            cp "$selected" "$DIR/"
            rm "$selected"
            echo "File restored."
            ;;
        2)
            rm "$selected"
            echo "File deleted."
            ;;
        3)
            echo "File left in quarantine."
            ;;
        *)
            echo "Invalid action."
            ;;
    esac
done
