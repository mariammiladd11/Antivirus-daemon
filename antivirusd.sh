#!/bin/bash
# antivirusd.sh dir malicious_dir interval-secs
if [ $# -ne 3 ]; then
    echo "Usage: $0 dir malicious_dir interval-secs" >&2
    exit 1
fi

DIR="$1"
MAL_DIR="$2"
INTERVAL="$3"


if [ ! -d "$DIR" ]; then
    echo "Error: $DIR is not a directory" >&2
    exit 1
fi

mkdir -p "$MAL_DIR"
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [ "$INTERVAL" -lt 1 ]; then
    echo "Error: interval-secs must be a positive integer" >&2
    exit 1
fi


LAST="directory-info.last"
NEW="directory-info.new"


snapshot() {
    ls -l "$DIR" > "$1"
}
echo "Monitoring $DIR, quarantine is $MAL_DIR, interval is $INTERVAL seconds"
snapshot "$LAST"
echo "Snapshot saved to $LAST"
