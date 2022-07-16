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

# Parse arguments
while getopts "uki" FLAG; do
    case "$FLAG" in
        u) BUILD_UBOOT=true ;;
        k) BUILD_KERNEL=true ;;
        i) BUILD_IMAGE=true ;;
        *) fail "Incorrect usage." ;;
    esac
done

# Initialize the submodules
git submodule init && git submodule update --recursive || fail "Failed to initialize and update submodules."

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
