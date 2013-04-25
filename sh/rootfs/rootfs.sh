#!/bin/bash

rootfs=$1

mkdir -p $rootfs/bin $rootfs/usr/lib/system
cp /usr/lib/dyld $rootfs/usr/lib

cpdeps(){
    echo Parsing $* ...;
	for dep in $*; do 
		rel=$(echo $dep | cut -c 2-)
		if [ ! -e $rootfs/$rel ]; then
            cp /$rel $rootfs/$rel;
            deps=$(otool -L $dep | tail -n +2 | awk '{print $1}');
            cpdeps $deps;
		fi;
	done;
}

cpdeps /bin/busybox;

bash -c "cd $rootfs/bin; busybox --list | xargs -I {} ln -s busybox {}"
