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

echo "Monitoring $DIR, quarantine is $MAL_DIR, interval is $INTERVAL secon
