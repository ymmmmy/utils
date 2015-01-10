#!/bin/bash

if [ $# -ne 2 ];then
    echo "Usage: ./onsen_rec.sh [Program Name] [drop box path]"
    exit 1
fi

PROGRAM=$1
DROPBOXPATH=$2
FILEPATH="/var/www/html/dav/radio"
if [ ! -e "${FILEPATH}/${PROGRAM}" ];then
    sudo mkdir -p "${FILEPATH}/${PROGRAM}"
fi
PRECODE="onsen`date +%w%d%H`"
PDATA="code=`echo ${PRECODE} | openssl dgst -md5 | sed -e 's/(stdin)= //'`\&file%5Fname=regular%5F"
URL="http://onsen.ag/getXML.php?`date +%s`000"
WGETOPTION="-q"
REGXMLNUM=`date +%w`
XMLFILE="/tmp/onsen.xml"
wget ${WGETOPTION} --post-data="${PDATA}${REGXMLNUM}" ${URL} -O ${XMLFILE}

NUM=`fgrep -A 1 "titleHeader" ${XMLFILE} | fgrep -A 1 ${PROGRAM} | tail -1 | sed -e 's/<[^>]*>//g' | sed -e 's/ //g'`
FILEURL=`fgrep "<fileUrl>" ${XMLFILE} | fgrep ${PROGRAM} | sed -e 's/<[^>]*>//g' | sed -e 's/ //g'`
wget ${FILEURL} -O "${FILEPATH}/${PROGRAM}/${PROGRAM}_${NUM}.mp3"

cp -p "${FILEPATH}/${PROGRAM}/${PROGRAM}_${NUM}.mp3" "${DROPBOXPATH}"

chown -R yamu:yamu "${DROPBOXPATH}"
