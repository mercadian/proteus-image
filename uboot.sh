#!/bin/bash

# Text colors
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;36m'
COLOR_RESET='\033[0m'

# Error message and exit function
fail() {
    MESSAGE=$1
    >&2 echo -e "\n${COLOR_RED}**ERROR**\n$MESSAGE${COLOR_RESET}"
    exit 1
}

cd /src/radxa

# Build the boot image
echo -e "${COLOR_BLUE}=== Building U-Boot Image for Rock 5B ===${COLOR_RESET}"
./build/mk-uboot.sh rock-5b || fail "Failed to build u-boot image."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

# Generate a .deb for the bootloader
echo -e "${COLOR_BLUE}=== Generating U-Boot Package ==="
./build/pack-uboot.sh -b rock-5b || fail "Failed to create u-boot package.${COLOR_RESET}"
echo -e "${COLOR_GREEN}=== Generation Successful! ===${COLOR_RESET}\n"

# Copy the package over to the OS image dir
echo -e "${COLOR_BLUE}=== Copying Package to OS Image Dir ===${COLOR_RESET}"
rm -f ./debos/rootfs/packages/arm64/u-boot/rock-5b* || fail "Failed to remove old u-boot packages."
cp ./out/packages/rock-5b*.deb ./debos/rootfs/packages/arm64/u-boot/ || fail "Failed to copy u-boot package."
echo -e "${COLOR_GREEN}=== Copy Successful! ===${COLOR_RESET}"

echo -e "${COLOR_GREEN}U-Boot successfully built.${COLOR_RESET}\n"
