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

# The rsync parameters to omit binary swiftmodule files in favor of swiftinterface files
#
# Note: Be sure to directly expand this variable (not surrounded in quotes) to have rsync treat these as 3 separate parameters
RSYNC_EXCLUDE_PARAMS="--exclude '*.swiftsourceinfo' --exclude '*.swiftdoc' --exclude '*.swiftmodule'"

# Invoke rsync -a but exclude binary swift module definition files since we prefer swiftinterface files for compatibility
#
# \param $@ additional arguments to rsync, see man rsync for more details
function rsync_excluding_binary_swift_module_files()
{
    rsync -a --exclude '*.swiftsourceinfo' --exclude '*.swiftdoc' --exclude '*.swiftmodule' "$@"
}

# Build up our output directory in Products/nuget
PRODUCTS_DIR="DerivedData/Build/Products"
NUGET_OUTPUT_DIR="$PRODUCTS_DIR/nuget"
make_dir_if_necessary "$NUGET_OUTPUT_DIR"

NUGET_OUTPUT_INCLUDE_DIR="$NUGET_OUTPUT_DIR/include"
make_dir_if_necessary "$NUGET_OUTPUT_INCLUDE_DIR"

NUGET_OUTPUT_INCLUDE_DIR_IOS="$NUGET_OUTPUT_INCLUDE_DIR/ios"
make_dir_if_necessary "$NUGET_OUTPUT_INCLUDE_DIR_IOS"

# Copy a single generated header into our output directory in an includes folder. Pick the release device header since that's likely the most important target
# Include the -m flag for not copying empty folders
rsync -am "DerivedData/Build/Intermediates.noindex/FluentUI.build/Release-iphoneos/FluentUILib.build/DerivedSources/FluentUILib-Swift.h" "$NUGET_OUTPUT_INCLUDE_DIR_IOS/FluentUILib-Swift.h"

# cd into the products directory to make copying all the output easier
cd $PRODUCTS_DIR

# Copy each platform
make_dir_if_necessary "nuget/Debug-macosx"
rsync_excluding_binary_swift_module_files Debug/FluentUI.framework/ nuget/Debug-macosx/FluentUI.framework/

make_dir_if_necessary "nuget/Ship-macosx"
rsync_excluding_binary_swift_module_files Release/FluentUI.framework/ nuget/Ship-macosx/FluentUI.framework/

make_dir_if_necessary "nuget/Debug-iphoneos"
rsync -a Debug-iphoneos/libFluentUILib.a nuget/Debug-iphoneos/
rsync_excluding_binary_swift_module_files Debug-iphoneos/FluentUILib.swiftmodule/ nuget/Debug-iphoneos/FluentUILib.swiftmodule/
rsync -a Debug-iphoneos/FluentUIResources-ios.bundle/ nuget/Debug-iphoneos/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Ship-iphoneos"
rsync -a Release-iphoneos/libFluentUILib.a nuget/Ship-iphoneos/
rsync_excluding_binary_swift_module_files Release-iphoneos/FluentUILib.swiftmodule/ nuget/Ship-iphoneos/FluentUILib.swiftmodule/
rsync -a Release-iphoneos/FluentUIResources-ios.bundle/ nuget/Ship-iphoneos/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Debug-iphonesimulator"
rsync -a Debug-iphonesimulator/libFluentUILib.a nuget/Debug-iphonesimulator/
rsync_excluding_binary_swift_module_files Debug-iphonesimulator/FluentUILib.swiftmodule/ nuget/Debug-iphonesimulator/FluentUILib.swiftmodule/
rsync -a Debug-iphonesimulator/FluentUIResources-ios.bundle/ nuget/Debug-iphonesimulator/FluentUIResources-ios.bundle/

make_dir_if_necessary "nuget/Ship-iphonesimulator"
rsync -a Release-iphonesimulator/libFluentUILib.a nuget/Ship-iphonesimulator/
rsync_excluding_binary_swift_module_files Release-iphonesimulator/FluentUILib.swiftmodule/ nuget/Ship-iphonesimulator/FluentUILib.swiftmodule/
rsync -a Release-iphonesimulator/FluentUIResources-ios.bundle/ nuget/Ship-iphonesimulator/FluentUIResources-ios.bundle/

# cd into our nuget folder to finally zip up our build output
cd "nuget"

# Zip the build output
echo "Creating zip archive named BuildOutput.zip containing all the platform folders"
zip --symlinks -r BuildOutput.zip Debug-macosx/ Ship-macosx/ Debug-iphoneos/ Ship-iphoneos/ Debug-iphonesimulator/ Ship-iphonesimulator/ include/

exit $?
