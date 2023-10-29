#!/bin/sh

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

COMPILE_CMD="arduino-cli compile"
MONITOR_GREP_TOKEN="arduino-cli monitor"

echo "[INFO] PORT: $PORT"
echo "[INFO] MONITOR_TOKEN: $MONITOR_GREP_TOKEN"
echo "[INFO] COMPILE_CMD: $COMPILE_CMD"

kill_monitor() {
  echo '[INFO] killing monitor ...'
  ps aux |
    grep "$MONITOR_GREP_TOKEN" |
    grep "$PORT" |
    grep -v 'monitor-and-upload' |
    grep -v 'compile-and-kill' |
    grep -v grep |
    grep -v kill |
    awk '{ print $2 }' |
    xargs kill
}

while true; do
  echo '[WAITING] press return to compile, "u" to uplaod without compiling'
  read LINE
  if [ "$LINE" = "u" ]; then
    kill_monitor
    continue;
  fi
  echo "[INFO] compiling ..."
  $COMPILE_CMD
  EXIT_CODE=$?
  echo "[INFO] compile exit code: $EXIT_CODE"
  if [ $EXIT_CODE -ne 0 ]; then
    echo "[ERROR] compilation FAILED! continue loop"
    continue
  fi
  kill_monitor
done
