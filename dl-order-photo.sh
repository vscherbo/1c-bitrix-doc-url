#!/bin/sh

. /usr/local/bin/bashlib

ECHO=echo


DT=`date +%F_%H_%M_%S`
BIN_DIR=`dirname $0`
PRC_NAME=`namename $0`
WRK_DIR=${BIN_DIR%/bin}

DST_DIR=$WRK_DIR/dst.local
LOG_DIR=$WRK_DIR/logs
LOG=$LOG_DIR/$PRC_NAME-$DT.log
LANG=en_US.UTF-8

$ECHO wget --no-clobber -o $LOG -i $WRK_DIR/dl-photo.txt
#$ECHO sed -r -e s_/.*/__g dev-photo-urls.txt > dev-photo-files.txt
