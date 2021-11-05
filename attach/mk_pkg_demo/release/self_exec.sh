#!/bin/sh
set -e
UPGRADE_DIR="/tmp/unpkg"
line=`wc -l $0 | awk '{print $1}'`;
line=`expr $line - 12`; #减去的数值为exit所在行号
mkdir -p $UPGRADE_DIR
tail -n $line $0 | tar x -C $UPGRADE_DIR
cd $UPGRADE_DIR
./start_upgrade.sh
RET=$?
if [ $RET -eq 0 ]; then rm -rf $UPGRADE_DIR; fi
exit $RET
#-------tar file---begin
