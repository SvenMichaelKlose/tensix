#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
#
# $License$

chkargs $1

case $MODE in
build)
    compile disk.c eth.c
    compile_native con_wrapper.c disk_wrapper.c tapdev.c machdep_wrapper.c uip_arch.c
    ;;

clean)
    clean
    ;;
esac
