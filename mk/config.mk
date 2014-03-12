#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002, 2003, 2004, 2005, 2006 Sven Klose <pixel@copei.de>
#
# $License$

. ../mk/main.mk

PWD=`pwd`

CC="bcc"
COPTS="-I. -I$PWD/include -0 -DK_AND_R -c"
LD="ld86"
LDOPTS="-0 -s -T 0xe000 -o"
AS="as86"
ASOPTS="-0 -o"

chkargs $1
subdir kern "kernel"
subdir fs "filesystems"
subdir arch "machine-dependent section"

# Link everything on a build.
case $1 in
build)
    link kernel
    ls -la kernel
    ;;
esac
