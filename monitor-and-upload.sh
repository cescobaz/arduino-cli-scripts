#!/bin/bash

DIR=$(dirname $(realpath $0))
echo "[INFO] DIR $DIR"

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--port)
      PORT="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      echo "Unknown arg $1"
      exit 1
      ;;
  esac
done

if [ -z ${PORT+x} ]; then
  echo "[ERROR] missing parameter -p/--port"
  echo "[ERROR] use 'arduino-cli board list' to list available ports"
  exit 1
fi

MONITOR_CMD="arduino-cli monitor -p $PORT"
UPLOAD_CMD="arduino-cli upload -p $PORT"

echo "[INFO] PORT: $PORT"
echo "[INFO] MONITOR_CMD: $MONITOR_CMD"
echo "[INFO] UPLOAD_CMD: $UPLOAD_CMD"

while true; do
  echo '[INFO] start monitor'
  $MONITOR_CMD
  echo '[INFO] killed monitor'
  echo '[INFO] start upload'
  $UPLOAD_CMD
done
