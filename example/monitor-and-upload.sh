#!/bin/sh

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
      shift
      ;;
  esac
done

if [ -z ${PORT+x} ]; then
  echo "[ERROR] missing parameter -p/--port"
  exit 1
fi

DIR=$(dirname $(realpath $0))
echo "[INFO] DIR $DIR"

../monitor-and-upload.sh --port $PORT \
  --monitor-cmd "$DIR/monitor.sh --port $PORT"
