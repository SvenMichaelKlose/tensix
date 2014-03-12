#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002 Sven Klose <pixel@hugbox.org>
#
# $License$

#. ../../../mk/main.mk
chkargs $1
subdir bcc "BCC library"
subdir drivers "drivers"

case $MODE in
build)
    compile *.c
    assemble *.s
    ;;
clean)
    clean
    ;;
esac
