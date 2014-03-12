#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002 Sven Klose <pixel@copei.de>
#
# $License$

#. ../../mk/main.mk
chkargs $1

case $ARCH in
i86)
    subdir i86 "i86 support"
    ;;

unix)
    subdir unix "UNIX userland support"
    ;;

cpc)
#    subdir cpc "generic support"
    ;;

*)
    echo "Missing ARCH: i86 or unix."
    exit -1
    ;;
esac
