#!/bin/bash

# Copy the correct GoogleService-Info.plist based on build configuration

# Get the configuration name
CONFIG_NAME="${CONFIGURATION}"

# Determine which flavor we're building
if [[ "$CONFIG_NAME" == *"-dev"* ]] || [[ "$CONFIG_NAME" == "Debug" ]]; then
    FLAVOR="dev"
elif [[ "$CONFIG_NAME" == *"-uat"* ]]; then
    FLAVOR="uat"
elif [[ "$CONFIG_NAME" == *"-prod"* ]] || [[ "$CONFIG_NAME" == "Release" ]] || [[ "$CONFIG_NAME" == "Profile" ]]; then
    FLAVOR="prod"
else
    echo "Warning: Unknown configuration '$CONFIG_NAME', defaulting to dev"
    FLAVOR="dev"
fi

# Source and destination paths
SOURCE_PLIST="${PROJECT_DIR}/config/${FLAVOR}/GoogleService-Info.plist"
DEST_PLIST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

echo "Copying GoogleService-Info.plist for flavor: ${FLAVOR}"
echo "Source: ${SOURCE_PLIST}"
echo "Destination: ${DEST_PLIST}"

if [ -f "$SOURCE_PLIST" ]; then
    cp "$SOURCE_PLIST" "$DEST_PLIST"
    echo "Successfully copied GoogleService-Info.plist for ${FLAVOR}"
else
    echo "Error: GoogleService-Info.plist not found at ${SOURCE_PLIST}"
    exit 1
fi
