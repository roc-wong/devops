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

cd /etc/yum.repos.d/
mkdir -p bak
mv * bak/

wget -O /etc/yum.repos.d/CentOS-Base.repo https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo

yum remove  -y  epel-release

yum install -y  https://repo.huaweicloud.com/epel/epel-release-latest-7.noarch.rpm

rm -rf epel-testing.repo

sed -i "s/#baseurl/baseurl/g" /etc/yum.repos.d/epel.repo
sed -i "s/mirrorlist/#mirrorlist/g" /etc/yum.repos.d/epel.repo
sed -i "s@http://download.fedoraproject.org/pub@https://repo.huaweicloud.com@g" /etc/yum.repos.d/epel.repo

yum clean all
yum makecache
yum repolist all

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo