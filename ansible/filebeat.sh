#!/bin/bash - 
#===============================================================================
#
#          FILE: start.sh
# 
#         USAGE: ./start.sh 
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

agent="/usr/local/filebeat/filebeat"
args="-c /usr/local/filebeat/filebeat.yml -path.home /usr/local/filebeat"

test_config() {
    ${agent} ${args} test config
}

start() {
    pid=`ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep |awk '{print $2}'`
    if [ ! "$pid" ];then
        test_config
        if [ $? -ne 0 ]; then
            echo "Error! filebeat test config failed."
            exit 1
        fi
        nohup ${agent} ${args} run > /dev/null 2>&1 &
        if [ $? == '0' ];then
            pid=`ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep |awk '{print $2}'`
            echo "start filebeat [${pid}] success."
        else
            echo "start filebeat failed."
        fi
    else
        echo "filebeat is still running [${pid}] !"
        exit
    fi
}
stop() {
    pid=`ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep |awk '{print $2}'`
    if [ ! "$pid" ];then
        echo "filebeat is not running"
    else
        kill ${pid}
        echo -n "Stopping filebeat ${pid}"
    fi
}
restart() {
    stop && start
}

status(){
    pid=`ps -ef | grep /usr/local/filebeat/filebeat.yml | grep -v grep |awk '{print $2}'`
    if [ ! "$pid" ];then
        echo "filebeat is not running"
    else
        echo "filebeat is running [${pid}]"
    fi
}
case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        restart
    ;;
    status)
        status
    ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
esac
