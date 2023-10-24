#!/bin/bash

DIR=$(dirname $(realpath $0))
echo "[INFO] DIR $DIR"

POSITIONAL_ARGS=()

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--port)
      PORT="$2"
      shift
      shift
      ;;
    -m|--monitor-cmd)
      MONITOR_CMD="$2"
      shift
      shift
      ;;
    -u|--upload-cmd)
      UPLOAD_CMD="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z ${PORT+x} ]; then
  echo "[ERROR] missing parameter -p/--port"
  exit 1
fi

if [ -z ${MONITOR_CMD+x} ]; then
  MONITOR_CMD="arduino-cli monitor -p $PORT"
fi

if [ -z ${UPLOAD_CMD+x} ]; then
  UPLOAD_CMD="arduino-cli upload -p $PORT $PWD"
fi

echo "[INFO] PORT: $PORT"
echo "[INFO] MONITOR_CMD: $MONITOR_CMD"
echo "[INFO] UPLOAD_CMD: $UPLOAD_CMD"

while true; do
  echo '[INFO] start monitor'
  $MONITOR_CMD
  echo '[INFO] killed monitor'
  echo '[INFO] start upload'
  echo "$UPLOAD_CMD"
  $UPLOAD_CMD
done
