#!/bin/bash

# Invoke xcodebuild
#
# Match Azure DevOps xcodebuild invocations by not codesigning on CI builds
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

# Run an iOS simulator xcodebuild invocation with the specified scheme, configuration, and build commands
#
# \param $1 scheme
# \param $2 configuration
# \param $3+ build commands
function ios_simulator_build()
{
    invoke_xcodebuild workspace "ios/FluentUI.xcworkspace" "$1" "$2" iphonesimulator "${@:3}" -destination "platform=iOS Simulator,name=iPhone 8"
    return $?
}

# Run an iOS device xcodebuild invocation with the specified scheme, configuration, and build commands
#
# \param $1 scheme
# \param $2 configuration
# \param $3+ build commands
function ios_device_build()
{
    invoke_xcodebuild workspace "ios/FluentUI.xcworkspace" "$1" "$2" iphoneos "${@:3}"
    return $?
}

# Run a macOS build and test with the specified scheme, configuration, and build commands
# 
# \param $1 scheme
# \param $2 configuration
# \param $3+ build commands
function macos_build()
{
    invoke_xcodebuild project "macos/xcode/OfficeUIFabric.xcodeproj" "$1" "$2" macosx "${@:3}"
    return $?
}

# Execute commands passed in to this script and forward on the exit code.
"$@"
exit $?
