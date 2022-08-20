#!/bin/bash

# Text colors
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;36m'
COLOR_RESET='\033[0m'

DEBOS_PKG_DIR="/src/radxa/debos/rootfs/packages/arm64/kernel"

# Error message and exit function
fail() {
    MESSAGE=$1
    >&2 echo -e "\n${COLOR_RED}**ERROR**\n$MESSAGE${COLOR_RESET}"
    exit 1
}

# Look for the signing key
SIGN_ARGS="-us -uc"
KEY_OUTPUT=$(gpg --list-secret-keys | grep "3349ACE3C9902BFA127F0B6B0521ED0610CE5799")
if [ "$KEY_OUTPUT" != "" ]; then
    SIGN_ARGS=""
else
    echo -e "${COLOR_YELLOW}NOTE: Mercadian signing key not detected, building unsigned packages.${COLOR_RESET}"
fi

# Clean the old packages
rm -f $DEBOS_PKG_DIR/proteus-overlay*.deb
cd /src/proteus-overlay-pkg

# Build the package
echo -e "${COLOR_BLUE}=== Building the Proteus Device Tree Overlay Package ===${COLOR_RESET}"
debuild -b $SIGN_ARGS -aarm64 || fail "Failed to build the package."

# Move the build artifacts
echo -e "${COLOR_BLUE}=== Copying Package to Debos Dir ===${COLOR_RESET}"
#mv ../*.build ../*.buildinfo ../*.changes ../*.deb out || fail "Failed to move the output files."
rm -f ../*.build ../*.buildinfo ../*.changes
mv ../*.deb /src/radxa/debos/rootfs/packages/arm64/kernel || fail "Failed to move the package."
echo -e "${COLOR_GREEN}=== Build Successful! ===${COLOR_RESET}\n"

# List the output
echo "Output package:"
find /src/radxa/debos/rootfs/packages/arm64/kernel -name "proteus-overlay*.deb"
echo -e "${COLOR_GREEN}=== Copy Successful! ===${COLOR_RESET}"

echo -e "${COLOR_GREEN}Package successfully built.${COLOR_RESET}\n"
