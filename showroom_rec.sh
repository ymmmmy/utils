#!/bin/bash

while getopts c:d: opt
do
    case $opt in
        c) CH=${OPTARG} ;;
        d) DIR=${OPTARG} ;;
    esac
done

if [ ! ${CH} ];then
    echo "usage: $0 -c channel [-d dirctory]"
    exit 1;
fi

U_TIME=`date +%s`
DATE=`date -d @${U_TIME} +%Y%m%d`
SAVE_DIR="~/${CH}"
if [ ${DIR} ];then
    SAVE_DIR="${DIR}/${CH}"
    mkdir -p ${SAVE_DIR}
fi
FILE="${CH}_${DATE}.flv"
DATA=`curl -s https://www.showroom-live.com/${CH} | fgrep 'var data' | cut -d'{' -f2- | sed 's/^{//g' | sed 's/};$//g'`
URL=`echo ${DATA} | sed 's/,/\n/g' | sort -u | fgrep '"streaming_url_rtmp"' | cut -d':' -f2- | sed 's/"//g'`
KEY=`echo ${DATA} | sed 's/,/\n/g' | sort -u | fgrep '"streaming_key"' | cut -d':' -f2- | sed 's/"//g'`

if [ -e "${SAVE_DIR}/${FILE}" ];then
    FILE="${CH}_$DATE_${U_TIME}.flv"
fi

/usr/local/bin/rtmpdump -r "${URL}" -a "liveedge" -W "https://www.showroom-live.com/assets/swf/ShowRoomLive.swf" -p "https://www.showroom-live.com/${CH}" --live -y "${KEY}" -o "${SAVE_DIR}/${FILE}"
