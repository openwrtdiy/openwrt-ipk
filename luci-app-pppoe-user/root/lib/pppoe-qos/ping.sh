#!/bin/sh

. /lib/functions/network.sh
. /lib/functions/procd.sh

PING_TIME="$(date "+%Y-%m-%d_%H:%M:%S")"
PING_LIST="/home/log/hostping"
PING_HOST="www.google.com"
PING_FILE="${PING_LIST}/$PING_HOST.log"
PING_INTERFACE="eth18"
PING_COUNT="5"
PING_PACKETSIZE="56"
PING_MAX_TTL="60"

# Check link quality #
PING_TIMEOUT="4"
PING_INTERVAL="30"

PING="ping $PING_HOST -I $PING_INTERFACE -c $PING_COUNT -s $PING_PACKETSIZE -t $PING_MAX_TTL"

mkdir -p ${PING_LIST}

echo "$PING_TIME $PING" >> "$PING_FILE"







