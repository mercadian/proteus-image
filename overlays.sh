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

cd /src/dtoverlays/proteus

# Build the STA LED Overlay
echo -e "${COLOR_BLUE}=== Building STA LED Overlay ===${COLOR_RESET}"
dtc -O dtb -o sta-led-overlay.dtbo -@ sta-led-overlay.dts || fail "Failed to build overlay."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

# Copy the overlay to the kernel dir
echo -e "${COLOR_BLUE}=== Copying Overlay to Kernel Dir ===${COLOR_RESET}"
rm -f /src/radxa/kernel/arch/arm64/boot/dts/rockchip/overlay/sta-led-overlay.dtbo || fail "Failed to remove old overlay."
cp sta-led-overlay.dtbo /src/radxa/kernel/arch/arm64/boot/dts/rockchip/overlay/ || fail "Failed to copy overlay."
echo -e "${COLOR_GREEN}=== Copy Successful! ===${COLOR_RESET}"

echo -e "${COLOR_GREEN}Kernel successfully built.${COLOR_RESET}\n"
