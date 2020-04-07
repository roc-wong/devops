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

VERSION=1.6.0-SNAPSHOT

docker tag apollo-configservice:$VERSION 10.29.139.47:5001/framework/apollo-configservice:$VERSION
docker tag apollo-adminservice:$VERSION 10.29.139.47:5001/framework/apollo-adminservice:$VERSION
docker tag apollo-portal:$VERSION 10.29.139.47:5001/framework/apollo-portal:$VERSION

docker push 10.29.139.47:5001/framework/apollo-configservice:$VERSION
docker push 10.29.139.47:5001/framework/apollo-adminservice:$VERSION
docker push 10.29.139.47:5001/framework/apollo-portal:$VERSION


docker rm -f apollo-adminservice apollo-configservice
docker rmi registry.cn-hangzhou.aliyuncs.com/zts-framework/apollo-configservice:1.6.0-SNAPSHOT registry.cn-hangzhou.aliyuncs.com/zts-framework/apollo-adminservice:1.6.0-SNAPSHOT
docker rmi 10.29.139.47:5001/framework/apollo-configservice:1.6.0-SNAPSHOT 10.29.139.47:5001/framework/apollo-adminservice:1.6.0-SNAPSHOT
