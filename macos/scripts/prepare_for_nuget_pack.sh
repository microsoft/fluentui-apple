#!/bin/bash

# NuGet packing doesn't support symlinks, so zip up our frameworks first to preserve the symlinks
cd "DerivedData/OfficeUIFabric/Build/Products/"

if ! [ -d "Debug-macosx" ]; then
    echo "Making Debug-macosx folder"
    mkdir "Debug-macosx"
else
    echo "Debug-macosx folder already exists"
fi

rsync -a Debug/OfficeUIFabric.framework/ Debug-macosx/OfficeUIFabric.framework/

if ! [ -d "Ship-macosx" ]; then
    echo "Making Ship-macosx folder"   
    mkdir "Ship-macosx"
else
    echo "Ship-macosx folder already exists"
fi

rsync -a Release/OfficeUIFabric.framework/ Ship-macosx/OfficeUIFabric.framework/

echo "Creating zip archive named BuildOutput.zip containing Debug-macosx and Ship-macosx"
zip --symlinks -r BuildOutput.zip Debug-macosx/ Ship-macosx/
