#!/bin/bash

# Tweak our build number and export it as a variable for the nuget packing script

echo "Source Branch Name: $BUILD_SOURCEBRANCHNAME"
echo "Build Number: $BUILD_BUILDNUMBER"

echo "Adjusted BuildNumber: $BUILD_BUILDNUMBER"
echo "##vso[task.setvariable variable=sanitizedBuildNumber]$BUILD_BUILDNUMBER"
