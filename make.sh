#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002, 2003, 2004, 2005, 2006 <pixel@copei.de>
#
# $License$

. ./mk/main.mk

PWD=`pwd`

case $CONFIG in
"")
    echo "No CONFIG file specified."
    exit 1
    ;;
esac

MACHINE=$CONFIG
CONFIG="$PWD/conf/$CONFIG.h"
ARCHCONFIG="$PWD/arch/$ARCH/config.h"

case $HOST in
gcc)
    CC="gcc"
    CONFOPTS="-DARCHCONFIG=\"$ARCHCONFIG\" -DCONFIG=\"$CONFIG\" -DMACHINE=\"$MACHINE\" -D_GNU_SOURCE -D_BSD_SOURCE -D_SVID_SOURCE"
    COPTS=" -g -pipe -ansi -ffreestanding -Wall -Werror -O0 -I$PWD/include $CONFOPTS -c"
    NATIVE_CC=$CC
    NATIVE_COPTS="-g -Wall -Werror -O0 $CONFOPTS -c"
    AS=$CC
    ASOPTS=$COPTS
    LD="ld"
    LDOPTS="-lgcc -lc -o"
    ;;

sdcc)
    CC="sdcc"
    CONFOPTS="-mz80 --opt-code-size --callee-saves --fommit-frame-pointer -DARCHCONFIG=\\\"$ARCHCONFIG\\\" -DCONFIG=\\\"$CONFIG\\\" -DMACHINE=\"$MACHINE\""
    COPTS=" -I$PWD/include $CONFOPTS -c"
    AS=$CC
    ASOPTS=$COPTS
    LD="sdcc"
    LDOPTS=""
    ;;


*)
    echo "No HOST (gcc or bcc) specified."
    exit -1
    ;;
esac

case $1 in
build)
	HEADERFILES=`find . -name \*.h`
        if [ `find $HEADERFILES -newer tensix` ];
        then
		./make.sh clean
        fi
esac

chkargs $1
subdir lib "kernel library"
subdir kern "kernel"
subdir dev "device drivers"
subdir fs "filesystems"
subdir arch "machine-dependent section"
subdir contrib "third-party contributions"
subdir builtin "built-in applications"
subdir tests "tests"

# Link everything on a build.
case $1 in
build)
    link tensix
    ls -la tensix
    ;;
clean)
    clean
    rm tensix
esac
