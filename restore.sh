#!/bin/bash
# restore.sh dir malicious_dir

if [ $# -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir" >&2
    exit 1
fi

DIR="$1"
MAL_DIR="$2"
mkdir -p "$DIR"
shopt -s dotglob nullglob


get_files() {
    FILES=()
    local f
    for f in "$MAL_DIR"/*; do
        [ -f "$f" ] && FILES+=("${f##*/}")
    done
}

get_files
if [ ${#FILES[@]} -eq 0 ]; then
    echo "No malicious files to review."
    exit 0
fi

while true; do
    get_files
    if [ ${#FILES[@]} -eq 0 ]; then
        exit 0
    fi

    echo "Choose a file:"
    for i in "${!FILES[@]}"; do
        echo "$((i+1)): ${FILES[$i]}"
    done
    printf "> "
    read -r n || exit 0

    if ! [[ "$n" =~ ^[0-9]+$ ]] || [ "$n" -lt 1 ] || [ "$n" -gt "${#FILES[@]}" ]; then
        echo "Invalid choice."
        continue
    fi
    file="${FILES[$((n-1))]}"

    echo "For $file:"
    echo "1: Restore this file back into dir (it was a false positive)"
    echo "2: Permanently delete this file from malicious_dir (it was genuinely malicious)"
    echo "3: Go back"
    printf "> "
    read -r c || exit 0

    case "$c" in
        1)
            mv -- "$MAL_DIR/$file" "$DIR/$file"
            echo "Restored $file to $DIR."
            ;;
        2)
            rm -f -- "$MAL_DIR/$file"
            echo "$file permanently deleted."
            ;;
        3)
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
done
