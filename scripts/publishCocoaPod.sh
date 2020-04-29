#!/bin/bash

# A simple script to publish our pod to cocoapods.org. Run from the root of the repo.

# Note: In CI/CD scenarios, expect the COCOAPODS_TRUNK_TOKEN env variable to be set which allows this to run automatically
pod trunk push MicrosoftFluentUI.podspec
