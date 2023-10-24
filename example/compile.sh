#!/bin/sh

DIR=$(dirname $(realpath $0))
echo "[INFO] DIR $DIR"

arduino-cli compile -m development "$DIR"
