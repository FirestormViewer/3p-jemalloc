#!/bin/bash

cd "$(dirname "$0")"

set -xe

if [ -z "$AUTOBUILD" ] ; then
    fail
fi

SOURCE_DIR="jemalloc"

# load autbuild provided shell functions and variables
eval "$("$AUTOBUILD" source_environment)"

top="$(pwd)"
stage="$(pwd)/stage"


case "$AUTOBUILD_PLATFORM" in
        "linux64")

			cd ${top}/${SOURCE_DIR}
			#Workaround for braindead configure script with the source that insists on compiling with g3 (full debug syms),
			#just because the compiler happens to support it! Full debug syms makes the libraries massively larger compared to the originals.
			export CFLAGS="-g0"
			export CXXFLAGS="-g0"

			./autogen.sh
			make -j4

			mkdir -p ${stage}/lib/release/
			mkdir -p ${stage}/LICENSES/
			
			cp lib/* ${stage}/lib/release/
			echo "5.3.0" > ${stage}/VERSION.txt
			cp COPYING ${stage}/LICENSES/jemalloc.txt
			;;
		*)
			echo "Unsupported platform ${AUTOBUILD_PLATFORM}"
			exit 1
			;;
		esac
