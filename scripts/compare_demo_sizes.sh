#!/bin/bash

#simple scripts used to compare sizes of the iOS device release demo app

headSize=$(<$GITHUB_WORKSPACE/headSize)
baseSize=$(<$GITHUB_WORKSPACE/baseSize)
difference=$(($baseSize-$headSize))
echo "The FluentUI Demo app went from $headSize kB to $baseSize kB, resulting in a change of $difference kB"