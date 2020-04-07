#!/bin/bash

# Invoke xcodebuild
#
# \param $1 type of project (Project or Workspace)
# \param $2 path to  to run against
# \param $3 scheme to build
# \param $4 configuration
# \param $5 sdk
# \param $6+ build commands
function invoke_xcodebuild()
{
    /usr/bin/xcodebuild \
        -"$1" "$2" \
        -scheme "$3" \
        -configuration "$4" \
        -sdk "$5" \
        "${@:6}" \
        CODE_SIGNING_ALLOWED=NO
    
    return $?
}

# Run a macOS build and test with the specified configuration
# 
# \param $1 configuration
function macos_build_test()
{
    invoke_xcodebuild project "macos/xcode/OfficeUIFabric.xcodeproj" OfficeUIFabricTestApp "$1" macosx build test
}

# Run an iOS simulator xcodebuild invocation with the specified scheme, configuration, and build commands
#
# \param $1 scheme
# \param $2 configuration
# \param $3+ build commands
function ios_simulator()
{
    invoke_xcodebuild workspace "ios/OfficeUIFabric.xcworkspace" "$1" "$2" iphonesimulator "${@:3}" -destination "platform=iOS Simulator,name=iPhone 8"
}

# Run an iOS device xcodebuild invocation with the specified scheme and configuration
#
# \param $1 scheme
# \param $2 configuration
function ios_build_device()
{
    invoke_xcodebuild workspace "ios/OfficeUIFabric.xcworkspace" "$1" "$2" iphoneos build
}

echo "Building and Testing macOS Debug"
macos_build_test Debug

echo "Building and Testing macOS Release"
macos_build_test Release

echo "Building and Testing iOS Debug Simulator"
ios_simulator OfficeUIFabric Debug build test

echo "Building iOS Release Simulator"
ios_simulator OfficeUIFabric Release build

echo "Building iOS Testapp Debug Simulator"
ios_simulator Demo.Development Debug build

echo "Building iOS Testapp Release Simulator"
ios_simulator Demo.Development Release build

echo "Building iOS Testapp Debug Device"
ios_build_device Demo.Development Debug

echo "Building iOS Testapp Release Device"
ios_build_device Demo.Development Release
