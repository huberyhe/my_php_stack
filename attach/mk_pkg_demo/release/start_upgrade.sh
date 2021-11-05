#!/bin/sh
# 示例升级,替换文件
INSTALL_ROOT=/tmp/www
UNPKG_DIR=/tmp/unpkg
SRC_ROOT=${UNPKG_DIR}/src

rm -rf $INSTALL_ROOT
mkdir -p $INSTALL_ROOT
cp $SRC_ROOT/* $INSTALL_ROOT/ -Ra
