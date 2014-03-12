#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
#
# $License$

chkargs $1

case $MODE in
build)
    compile wrapfs.c
    compile_native wrapfs_wrap.c
    ;;

clean)
    ;;
esac
