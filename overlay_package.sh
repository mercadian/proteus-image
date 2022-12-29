#!/bin/bash

# Text colors
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;36m'
COLOR_RESET='\033[0m'

INCLUDE_DIR="/src/radxa/kernel/include"
ORIGINAL_DTS="user-led-overlay.dts"
PREPROCESSED_DTS="${ORIGINAL_DTS}.preprocessed"

# Error message and exit function
fail() {
    MESSAGE=$1
    >&2 echo -e "\n${COLOR_RED}**ERROR**\n$MESSAGE${COLOR_RESET}"
    exit 1
}

# Clean the old packages
cd /src/proteus-overlay-pkg
rm -f src/$PREPROCESSED_DTS
rm -rf out
mkdir -p out

# Preprocess the file
echo -e "${COLOR_BLUE}=== Preprocessing the Proteus Device Tree Overlay Package ===${COLOR_RESET}"
cpp -nostdinc -I $INCLUDE_DIR -undef -x assembler-with-cpp src/$ORIGINAL_DTS src/$PREPROCESSED_DTS
echo -e "${COLOR_GREEN}=== Preprocess Successful! ===${COLOR_RESET}\n"

# Build the package
echo -e "${COLOR_BLUE}=== Building the Proteus Device Tree Overlay Package ===${COLOR_RESET}"
debuild -b -us -uc -aarm64 || fail "Failed to build the package."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

# Move the build artifacts
echo -e "${COLOR_BLUE}=== Copying Package to Debos Dir ===${COLOR_RESET}"
mv ../*.build ../*.buildinfo ../*.changes ./*.dtbo ../*.deb out || fail "Failed to move the output files."

# List the output
echo "Output package:"
find . -name "proteus-overlay*.deb"
echo -e "${COLOR_GREEN}=== Copy Successful! ===${COLOR_RESET}"

echo -e "${COLOR_GREEN}Package successfully built.${COLOR_RESET}\n"
