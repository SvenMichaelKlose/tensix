#!/bin/sh
#
# tensix operating system project
# Copyright (C) 2002, 2003, 2004, 2005, 2006 Sven Klose <pixel@copei.de>
#
# $License$

# Print a message.
message() {
    echo "===> $1"
}

cmd() {
    echo $1
    $1 || exit 1
}

blindcmd() {
    echo $1
    $1
}

assemble() {
    local TMP

    for i
    do
	if find $i -newer $i".o";
	then
        	TMP = $AS $ASOPTS  $i".o" $i
		cmd $TMP
	fi
    done
};

# Compile all source files in the current directory.
compile() {
    local TMP
    local OBJ
    TMP="$CC $COPTS"

    for i
    do
    	OBJ=`echo $i | sed -e "s/\.c//g"`".o"
	if [ ! -f $OBJ ];
		then
        		cmd "$TMP $i"
	else
	if [ `find $i -newer $OBJ` ];
		then
        		cmd "$TMP $i"
	fi
	fi
    done
};

# Compile all source files in the current directory.
compile_native() {
    local TMP
    local OBJ
    TMP="$NATIVE_CC $NATIVE_COPTS"

    for i
    do
    	OBJ="$i.on"
	if [ ! -f $OBJ ];
	then
        	cmd "$TMP -o $OBJ $i"
	else
		if [ `find $i -newer $OBJ` ];
		then
        		cmd "$TMP -o $OBJ $i"
		fi
	fi
    done
};

# Process a subdirectory/
# $1: directory to process.
# $2: directory description.
execdir() {
    # Enter the subdirectory.
    echo "=>>> $MODETITLE $2"
    cd $1
    ./make.sh $MODE || exit 1
    cd ..
    #echo "<<<= $2 done."
}

# Process a subdirectory/
# $1: directory to process.
# $2: directory description.
subdir() {
    # Enter the subdirectory.
    echo "=>>> $MODETITLE $2"
    cd $1

    # Execute make script in subdirectory if exists.
    if [ -r makefile ];
    then
        . ./makefile
    else
        # Perform default ops on the subdir.
        case $MODE in
        build)
            for i in `find . -name \*.c`; do
                compile $i
            done
            for i in `find . -name \*.cn`; do
                compile_native $i
            done
            for i in `find . -name \*.s`; do
                assemble $i
            done
            ;;
        clean)
            clean
            ;;
        esac
    fi
    cd ..
    #echo "<<<= $2 done."
}

# Link all object files in the current directory branch.
link() {
    local OBJS
    local OBJSN

    message "Collecting object files for $1"

    OBJS=`find . -name \*.o | tr " " "\n" | sort`
    OBJSN=`find . -name \*.on | tr " " "\n" | sort`

    message "Linking $1"

    blindcmd "rm -f tensixkern.o tensixkern2.o"
    cmd "$LD -r -nostdlib -o tensixkern.o $OBJS "
    cmd "objcopy -G main -G panic tensixkern.o tensixkern2.o"
    cmd "mv tensixkern2.o tensixkern.o"
    cmd "$CC $LDOPTS $1 $OBJSN tensixkern.o"
    blindcmd "rm -f tensixkern.o"
}

# Clean the current directory.
clean() {
    rm -f *.o *.on symbols a.out *.core __tmp.c
}

# Process arguments to the script.
chkargs() {
    case $MODE in
    "")
        case $1 in
        build)
            MODETITLE="Building"
            ;;
        clean)
            MODETITLE="Cleaning"
            ;;
        *)
            echo "Make 'build' or 'clean'."
            exit 1
            ;;
        esac

        # Remember the mode.
        MODE=$1
    ;;
    esac
}
