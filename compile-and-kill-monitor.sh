#!/bin/sh

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--port)
      PORT="$2"
      shift
      shift
      ;;
    -c|--compile-cmd)
      COMPILE_CMD="$2"
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

if [ -z ${PORT+x} ]; then
  echo "[ERROR] missing parameter -p/--port"
  exit 1
fi

if [ -z ${COMPILE_CMD+x} ]; then
  COMPILE_CMD="arduino-cli compile"
fi

echo "[INFO] PORT: $PORT"
echo "[INFO] MONITOR_TOKEN: $MONITOR_TOKEN"
echo "[INFO] COMPILE_CMD: $COMPILE_CMD"

kill_monitor() {
  echo '[INFO] killing monitor ...'
  ps aux |
    grep "arduino-cli monitor" |
    grep "$PORT" |
    grep -v 'monitor-and-upload' |
    grep -v 'compile-and-kill' |
    grep -v grep |
    grep -v kill |
    awk '{ print $2 }' |
    tee /dev/null |
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
