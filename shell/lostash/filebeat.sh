#!/bin/bash -
#===============================================================================
#
#          FILE: filebeat.sh
#
#         USAGE: ./filebeat.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 06/12/2019 09:06:43 PM
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

KILL_ON_STOP_TIMEOUT=1

agent="/usr/local/filebeat/filebeat"
args="-c /usr/local/filebeat/filebeat.yml -path.home /usr/local/filebeat"
name=filebeat

test_config() {
  ${agent} ${args} test config
}

start() {
  pid=$(ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep | awk '{print $2}')
  if [ ! "$pid" ]; then
    test_config
    if [ $? -ne 0 ]; then
      echo "Error! filebeat test config failed."
      return 1
    fi
    nohup ${agent} ${args} run >/dev/null 2>&1 &
    if [ $? == '0' ]; then
      pid=$(ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep | awk '{print $2}')
      echo "start filebeat [${pid}] success."
      return 0
    else
      echo "start filebeat failed."
      return 1
    fi
  else
    echo "filebeat is still running [${pid}] !"
    return 1
  fi
}

stop() {
  # Try a few times to kill TERM the program
  if status; then
    pid=$(ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep | awk '{print $2}')
    echo -e "Killing $name (pid $pid) with SIGTERM \n"
    kill -TERM $pid
    # Wait for it to exit.
    for i in 1 2 3 4 5; do
      echo "Waiting $name (pid $pid) to die..."
      status || break
      sleep 1
    done
    if status; then
      if [ "$KILL_ON_STOP_TIMEOUT" -eq 1 ]; then
        echo "Timeout reached. Killing $name (pid $pid) with SIGKILL. This may result in data loss."
        kill -KILL $pid
        echo "$name killed with SIGKILL."
      else
        echo "$name stop failed; still running."
      fi
    else
      echo "$name stopped."
    fi
  else
    echo "$name is not running"
  fi

}

status() {

  pid=$(ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep | awk '{print $2}')
  if [ ! "$pid" ]; then
    return 3 # program is not running
  else
    if kill -0 $pid >/dev/null 2>/dev/null; then
      # process by this pid is running.
      # It may not be our pid, but that's what you get with just pidfiles.
      # TODO(sissel): Check if this process seems to be the same as the one we
      # expect. It'd be nice to use flock here, but flock uses fork, not exec,
      # so it makes it quite awkward to use in this case.
      return 0
    else
      return 2 # program is dead but pid file exists
    fi
  fi
}

force_stop() {
  if status; then
    stop
    status && kill -KILL $(ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep | awk '{print $2}')
  fi
}

case "$1" in
start)
  start
  ;;
stop)
  stop
  ;;
force-stop) force_stop ;;
restart)
  stop && start
  ;;
status)
  status
  code=$?
  if [ $code -eq 0 ]; then
    echo "$name is running"
  else
    echo "$name is not running"
  fi
  exit $code
  ;;
*)
  echo $"Usage: $0 {start|stop|restart|status|force_stop}"
  exit 3
  ;;
esac
exit $?