#!/bin/bash

# NuGet packing doesn't support symlinks, so zip up our frameworks first to preserve the symlinks

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

# Invoke rsync -am but exclude swiftsourceinfo and swiftdoc file types
#
# \param $@ additional arguments to rsync, see man rsync for more details
function rsync_excluding_swiftsourceinfo_swiftdoc()
{
    rsync -am --exclude '*.swiftsourceinfo' --exclude '*.swiftdoc' "$@"
}

# Invoke rsync_excluding_swiftsourceinfo_swiftdoc but also exclude nested .swiftmodule files.
# For use when rsync'ing an entire framework directory that contains a .swiftmodule folder
#
# \param $@ additional arguments to rsync, see man rsync for more details
function rsync_excluding_binary_swift_module_files_framework()
{
    rsync_excluding_swiftsourceinfo_swiftdoc --exclude '*.swiftmodule/*.swiftmodule' "$@"
}

# Invoke rsync_excluding_swiftsourceinfo_swiftdoc but also exclude .swiftmodule files.
# For use when rsync'ing an existing .swiftmodule folder
#
# \param $@ additional arguments to rsync, see man rsync for more details
function rsync_excluding_binary_swift_module_files_swiftmodule_folder()
{
    rsync_excluding_swiftsourceinfo_swiftdoc --exclude '*.swiftmodule' "$@"
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
rsync -a "DerivedData/Build/Intermediates.noindex/FluentUI.build/Release-iphonesimulator/FluentUILib.build/DerivedSources/FluentUILib-Swift.h" "$NUGET_OUTPUT_INCLUDE_DIR_IOS_FLUENTUI/FluentUI-Swift.h"

# cd into the products directory to make copying all the output easier
cd $PRODUCTS_DIR

# Copy each platform
make_dir_if_necessary "nuget/Debug-macosx"
rsync_excluding_binary_swift_module_files_framework Debug/FluentUI.framework/ nuget/Debug-macosx/FluentUI.framework/

make_dir_if_necessary "nuget/Ship-macosx"
rsync_excluding_binary_swift_module_files_framework Release/FluentUI.framework/ nuget/Ship-macosx/FluentUI.framework/

make_dir_if_necessary "nuget/Debug-iphoneos"
rsync -a Debug-iphoneos/libFluentUILib.a nuget/Debug-iphoneos/
rsync_excluding_binary_swift_module_files_swiftmodule_folder Debug-iphoneos/FluentUILib.swiftmodule/ nuget/Debug-iphoneos/FluentUILib.swiftmodule/
rsync -a Debug-iphoneos/FluentUIResources-ios.bundle/ nuget/Debug-iphoneos/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Ship-iphoneos"
rsync -a Release-iphoneos/libFluentUILib.a nuget/Ship-iphoneos/
rsync_excluding_binary_swift_module_files_swiftmodule_folder Release-iphoneos/FluentUILib.swiftmodule/ nuget/Ship-iphoneos/FluentUILib.swiftmodule/
rsync -a Release-iphoneos/FluentUIResources-ios.bundle/ nuget/Ship-iphoneos/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Debug-iphonesimulator"
rsync -a Debug-iphonesimulator/libFluentUILib.a nuget/Debug-iphonesimulator/
rsync_excluding_binary_swift_module_files_swiftmodule_folder Debug-iphonesimulator/FluentUILib.swiftmodule/ nuget/Debug-iphonesimulator/FluentUILib.swiftmodule/
rsync -a Debug-iphonesimulator/FluentUIResources-ios.bundle/ nuget/Debug-iphonesimulator/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Ship-iphonesimulator"
rsync -a Release-iphonesimulator/libFluentUILib.a nuget/Ship-iphonesimulator/
rsync_excluding_binary_swift_module_files_swiftmodule_folder Release-iphonesimulator/FluentUILib.swiftmodule/ nuget/Ship-iphonesimulator/FluentUILib.swiftmodule/
rsync -a Release-iphonesimulator/FluentUIResources-ios.bundle/ nuget/Ship-iphonesimulator/FluentUIResources-ios.bundle/

# cd into our nuget folder to finally zip up our build output
cd "nuget"

# Zip the build output
echo "Creating zip archive named BuildOutput.zip containing all the platform folders"
zip --symlinks -r BuildOutput.zip Debug-macosx/ Ship-macosx/ Debug-iphoneos/ Ship-iphoneos/ Debug-iphonesimulator/ Ship-iphonesimulator/ include/

exit $?
