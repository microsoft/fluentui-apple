#!/bin/bash

# A simple script to validate project settings.

if which swiftlint >/dev/null; then
    export LINTPATH="../."
    export EXCLUDELINTPATH="../tools"
    swiftlint --config ../.swiftlint.yml
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
