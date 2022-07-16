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

# Build the kernel
echo -e "${COLOR_BLUE}=== Building Kernel for Rock 5B ===${COLOR_RESET}"
./build/mk-kernel.sh rock-5b || fail "Failed to build kernel."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

# Generate a .deb for the kernel
echo -e "${COLOR_BLUE}=== Generating Kernel Package ==="
./build/pack-kernel.sh -d rockchip_linux_defconfig -r 1 || fail "Failed to create kernel packages.${COLOR_RESET}"
echo -e "${COLOR_GREEN}=== Generation Successful! ===${COLOR_RESET}\n"

# Copy the package over to the OS image dir
echo -e "${COLOR_BLUE}=== Copying Package to OS Image Dir ===${COLOR_RESET}"
rm -f ./debos/rootfs/packages/arm64/kernel/*5.10.66* || fail "Failed to remove old kernel packages."
cp ./out/packages/linux*.deb ./debos/rootfs/packages/arm64/kernel/ || fail "Failed to copy kernel packages."
echo -e "${COLOR_GREEN}=== Copy Successful! ===${COLOR_RESET}"

echo -e "${COLOR_GREEN}Kernel successfully built.${COLOR_RESET}\n"
