#!/bin/bash

# Text colors
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[33m'
COLOR_RESET='\033[0m'

# Error message and exit function
fail() {
    MESSAGE=$1
    >&2 echo -e "\n${COLOR_RED}**ERROR**\n$MESSAGE${COLOR_RESET}"
    exit 1
}

# Help text
help() {
    cat >&2 << helpText
Builds the Proteus OS image artifacts.

Usage: build.sh [-p -u -k -i]
Options:
    -h | --help  Prints this help text
    -p           Builds the device tree overlay package that makes the activity
                 LED work properly (required for the OS image)
    -u           Builds the U-Boot bootloader image (required for the OS image)
    -k           Builds the kernel and associated Debian packages (required for
                 the OS image)
    -i           Builds the OS image

helpText

    exit 0
}

for i in $*; do
    test "$i" == "-h" || test "$i" == "--help" && help
done

# Parse arguments
while getopts "puki" FLAG; do
    case "$FLAG" in
	    p) BUILD_OVERLAY_PACKAGE=true ;;
        u) BUILD_UBOOT=true ;;
        k) BUILD_KERNEL=true ;;
        i) BUILD_IMAGE=true ;;
        *) help ;;
    esac
done

# Build Overlays
if [ "$BUILD_OVERLAY_PACKAGE" = true ]; then
    docker run -it --rm --device /dev/kvm --security-opt label=disable --privileged --name proteus-build -v "$(dirname $(realpath $0)):/src" -w "/src" --entrypoint "/src/overlay_package.sh" mercadian/proteus-build:latest
fi

# Build U-Boot
if [ "$BUILD_UBOOT" = true ]; then
    docker run -it --rm --device /dev/kvm --security-opt label=disable --privileged --name proteus-build -v "$(dirname $(realpath $0)):/src" -w "/src" --entrypoint "/src/uboot.sh" mercadian/proteus-build:latest
fi

# Build Kernel
if [ "$BUILD_KERNEL" = true ]; then
    docker run -it --rm --device /dev/kvm --security-opt label=disable --privileged --name proteus-build -v "$(dirname $(realpath $0)):/src" -w "/src" --entrypoint "/src/kernel.sh" mercadian/proteus-build:latest
fi

# Build OS Image
if [ "$BUILD_IMAGE" = true ]; then
    docker run -it --rm --device /dev/kvm --security-opt label=disable --privileged --name proteus-build -v "$(dirname $(realpath $0)):/src" -w "/src" --entrypoint "/src/image.sh" mercadian/proteus-build:latest
fi
