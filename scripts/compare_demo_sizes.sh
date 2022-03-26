#!/bin/bash

#simple scripts used to compare sizes of the iOS device release demo app

headSize=$(<headSize/headSize)
baseSize=$(<baseSize/baseSize)
difference=$(($baseSize-$headSize))
echo "The FluentUI Demo app went from $headSize kB to $baseSize kB, resulting in a change of $difference kB"