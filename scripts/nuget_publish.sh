#!/bin/bash

# nuget_publish.sh
# A local version of the fluentui-apple-publish-nuget.yml Azure Pipeline that fires all the jobs sequentially.
# Useful for local validation, keep in sync with .ado/fluentui-apple-publish-nuget.yml
# Note: Execute this script from the root of the repository, such as `./scripts/nuget_publish.sh`

# Keep an exit code so that we can return a non-zero exit code if any build fails
# while still running all builds each time.
EXIT_CODE=0

# Path to the xcode build wrapper script
XCODEBUILD_WRAPPER_LOCATION='scripts/xcodebuild_wrapper.sh'

# Extra arguments for xcode build to mimic nuget publishing environment  
DERIVED_DATA_EXTRA_ARG='-derivedDataPath DerivedData'
IOS_XCCONFIG_EXTRA_ARG='-xcconfig .ado/xcconfig/publish_overrides_ios.xcconfig'
MACOS_XCCONFIG_EXTRA_ARG='-xcconfig .ado/xcconfig/publish_overrides_macos.xcconfig'

function handle_exit_code()
{
	if [ $? -ne 0 ]
	then
		echo "Previous command exited with non-zero exit code"
		# Intentionally changing the global EXIT_CODE variable
		EXIT_CODE=1
	fi
}

echo "Building and Testing macOS Debug"
$XCODEBUILD_WRAPPER_LOCATION macos_build FluentUI-macOS Debug build $DERIVED_DATA_EXTRA_ARG $MACOS_XCCONFIG_EXTRA_ARG
handle_exit_code

echo "Building and Testing macOS Release"
$XCODEBUILD_WRAPPER_LOCATION macos_build FluentUI-macOS Release build $DERIVED_DATA_EXTRA_ARG $MACOS_XCCONFIG_EXTRA_ARG
handle_exit_code

echo "Building iOS Static Lib Debug Simulator"
$XCODEBUILD_WRAPPER_LOCATION ios_simulator_build FluentUI-iOS-StaticLib Debug build $DERIVED_DATA_EXTRA_ARG $IOS_XCCONFIG_EXTRA_ARG
handle_exit_code

echo "Building iOS Static Lib Release Simulator"
$XCODEBUILD_WRAPPER_LOCATION ios_simulator_build FluentUI-iOS-StaticLib Release build $DERIVED_DATA_EXTRA_ARG $IOS_XCCONFIG_EXTRA_ARG
handle_exit_code

echo "Building Static Lib iOS Debug Device"
$XCODEBUILD_WRAPPER_LOCATION ios_device_build FluentUI-iOS-StaticLib Debug build $DERIVED_DATA_EXTRA_ARG $IOS_XCCONFIG_EXTRA_ARG
handle_exit_code

echo "Building iOS Release Static Lib Device"
$XCODEBUILD_WRAPPER_LOCATION ios_device_build FluentUI-iOS-StaticLib Release build $DERIVED_DATA_EXTRA_ARG $IOS_XCCONFIG_EXTRA_ARG
handle_exit_code

echo "Running scripts/prepare_for_nuget_pack.sh"
scripts/prepare_for_nuget_pack.sh
handle_exit_code

# Check if any of our individual build steps failed
if [ $EXIT_CODE -ne 0 ]
then
	echo "NuGet Pack Build Failed, please check logs for failures"
else
	echo "NuGet Pack Build Succeeded"
fi

exit $EXIT_CODE