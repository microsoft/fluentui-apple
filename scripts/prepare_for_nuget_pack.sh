#!/bin/bash

# NuGet packing doesn't support symlinks, so zip up our frameworks first to preserve the symlinks

# Fail if any of the commands fails to run
set -e

# Make a directory if necessary, no-op if it already exists
#
# \param $1 the name of the folder to create
function make_dir_if_necessary()
{
    if ! [ -d "$1" ]; then
        echo "Making $1 folder"
        mkdir "$1"
    else
        echo "$1 folder already exists"
    fi
}

# A thin wrapper around rsync to exclude specific swift source info files
#
# \param $1+ the standard input to rsync without any extra flags provided
function rsync_excluding_swift_source_info_files()
{
    rsync -a --exclude '*.swiftsourceinfo' --prune-empty-dirs "$@"
}

# Build up our output directory in Products/nuget
PRODUCTS_DIR="DerivedData/Build/Products"
NUGET_OUTPUT_DIR="$PRODUCTS_DIR/nuget"
make_dir_if_necessary "$NUGET_OUTPUT_DIR"

NUGET_OUTPUT_INCLUDE_DIR="$NUGET_OUTPUT_DIR/include"
make_dir_if_necessary "$NUGET_OUTPUT_INCLUDE_DIR"

NUGET_OUTPUT_INCLUDE_DIR_IOS="$NUGET_OUTPUT_INCLUDE_DIR/ios"
make_dir_if_necessary "$NUGET_OUTPUT_INCLUDE_DIR_IOS"

NUGET_OUTPUT_INCLUDE_DIR_IOS_FLUENTUI="$NUGET_OUTPUT_INCLUDE_DIR_IOS/FluentUI"
make_dir_if_necessary "$NUGET_OUTPUT_INCLUDE_DIR_IOS_FLUENTUI"

# Copy a single generated header into our output directory in an includes folder. Ensure we nest a FluentUI folder for proper `#import <FluentUI/FluentUI-Swift.h>` imports
# Pick the release simulator header since the device target has some arm64 specific ifdefs while the simulator version works on all platforms.
# Rename the FluentUILib-Swift.h to FluentUI-Swift.h for consistency with Framework consumption
echo "Copy iOS generated Swift header to include dir"
rsync -a "DerivedData/Build/Intermediates.noindex/FluentUI.build/Release-iphonesimulator/FluentUILib.build/DerivedSources/FluentUI-Swift.h" "$NUGET_OUTPUT_INCLUDE_DIR_IOS_FLUENTUI/FluentUI-Swift.h"

# cd into the products directory to make copying all the output easier
cd $PRODUCTS_DIR

# Copy each platform
make_dir_if_necessary "nuget/Debug-macosx"
echo "Copy Debug-macosx Framework into nuget folder"
rsync_excluding_swift_source_info_files Debug/FluentUI.framework/ nuget/Debug-macosx/FluentUI.framework/

make_dir_if_necessary "nuget/Ship-macosx"
echo "Copy Ship-macosx Framework into nuget folder"
rsync_excluding_swift_source_info_files Release/FluentUI.framework/ nuget/Ship-macosx/FluentUI.framework/

make_dir_if_necessary "nuget/Debug-iphoneos"
echo "Copy Debug-iphoneos build output into nuget folder"
rsync -a Debug-iphoneos/libFluentUI.a nuget/Debug-iphoneos/
rsync_excluding_swift_source_info_files Debug-iphoneos/FluentUI.swiftmodule/ nuget/Debug-iphoneos/FluentUI.swiftmodule/
rsync -a Debug-iphoneos/FluentUIResources-ios.bundle/ nuget/Debug-iphoneos/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Ship-iphoneos"
echo "Copy Ship-iphoneos build output into nuget folder"
rsync -a Release-iphoneos/libFluentUI.a nuget/Ship-iphoneos/
rsync_excluding_swift_source_info_files Release-iphoneos/FluentUI.swiftmodule/ nuget/Ship-iphoneos/FluentUI.swiftmodule/
rsync -a Release-iphoneos/FluentUIResources-ios.bundle/ nuget/Ship-iphoneos/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Debug-iphonesimulator"
echo "Copy Debug-iphonesimulator build output into nuget folder"
rsync -a Debug-iphonesimulator/libFluentUI.a nuget/Debug-iphonesimulator/
rsync_excluding_swift_source_info_files Debug-iphonesimulator/FluentUI.swiftmodule/ nuget/Debug-iphonesimulator/FluentUI.swiftmodule/
rsync -a Debug-iphonesimulator/FluentUIResources-ios.bundle/ nuget/Debug-iphonesimulator/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Ship-iphonesimulator"
echo "Copy Ship-iphonesimulator build output into nuget folder"
rsync -a Release-iphonesimulator/libFluentUI.a nuget/Ship-iphonesimulator/
rsync_excluding_swift_source_info_files Release-iphonesimulator/FluentUI.swiftmodule/ nuget/Ship-iphonesimulator/FluentUI.swiftmodule/
rsync -a Release-iphonesimulator/FluentUIResources-ios.bundle/ nuget/Ship-iphonesimulator/FluentUIResources-ios.bundle/

# cd into our nuget folder to finally zip up our build output
cd "nuget"

# Zip the build output
echo "Creating zip archive named BuildOutput.zip containing all the platform folders"
zip --symlinks -r BuildOutput.zip Debug-macosx/ Ship-macosx/ Debug-iphoneos/ Ship-iphoneos/ Debug-iphonesimulator/ Ship-iphonesimulator/ include/

exit $?
