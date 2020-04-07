#!/bin/bash -
#===============================================================================
#
#          FILE: get_user_token.sh
#
#         USAGE: ./get_user_token.sh
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

# Only 1 parameter !
if [[ $# != 1 ]];then
	echo " Usage: ./get_user_token.sh filename!";
    exit
fi

# check the file !
if [[ ! -f $1 ]];then
    echo "file does not exist!"
    exit 1
fi
if [[ ! -r $1 ]];then
    echo "file can not be read !"
    exit 1
fi

## PRESS ANY KEY TO CONTITUE !
#read -p "begin to read $1 "
#
## set IFS="\n" , read $1 file per line !
#IFS="
#"

cat $1 | while myline=$(line)
do
 echo "LINE:"${myline}
done

echo "Finished reading file by line ! "
exit 0