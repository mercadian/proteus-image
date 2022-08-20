#!/bin/bash

# Text colors
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;36m'
COLOR_RESET='\033[0m'

DEBOS_PKG_DIR="/src/radxa/debos/rootfs/packages/arm64/kernel"

# Error message and exit function
fail() {
    MESSAGE=$1
    >&2 echo -e "\n${COLOR_RED}**ERROR**\n$MESSAGE${COLOR_RESET}"
    exit 1
}

# Clean the old packages
rm -f $DEBOS_PKG_DIR/proteus-overlay*.deb
cd /src/proteus-overlay-pkg
mkdir -p out

# Build the package
echo -e "${COLOR_BLUE}=== Building the Proteus Device Tree Overlay Package ===${COLOR_RESET}"
debuild -b -us -uc -aarm64 || fail "Failed to build the package."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

# Move the build artifacts
echo -e "${COLOR_BLUE}=== Copying Package to Debos Dir ===${COLOR_RESET}"
mv ../*.build ../*.buildinfo ../*.changes ./*.dtbo ../*.deb out || fail "Failed to move the output files."
cp out/*.deb $DEBOS_PKG_DIR || fail "Failed to move the package."

# List the output
echo "Output package:"
find $DEBOS_PKG_DIR -name "proteus-overlay*.deb"
echo -e "${COLOR_GREEN}=== Copy Successful! ===${COLOR_RESET}"

echo -e "${COLOR_GREEN}Package successfully built.${COLOR_RESET}\n"
