#!/bin/bash

# A simple script to validate project settings.

if which swiftlint >/dev/null; then
    swiftlint --strict --config .swiftlint.yml
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
