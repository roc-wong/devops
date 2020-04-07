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

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker