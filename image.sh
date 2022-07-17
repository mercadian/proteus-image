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

cd /src/radxa/debos

# Build the image
echo -e "${COLOR_BLUE}=== Building OS Image Rock 5B ===${COLOR_RESET}"
./build.sh -c rk3588 -b rock-5b -m debian -d bullseye -v server -a arm64 -f gpt || fail "Failed to build image."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

echo -e "${COLOR_GREEN}Image successfully built.${COLOR_RESET}\n"
