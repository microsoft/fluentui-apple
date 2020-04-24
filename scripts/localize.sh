#!/bin/bash

printf "Team ID: "
read teamId

printf "Alias: "
read alias

stty -echo
printf "Password: "
read password
stty echo
printf "\n"

scripts/GetLocalizedFiles.sh -t $teamId -u -a $alias -p $password -f ios/FluentUI/Resources/Localization/en.lproj -r ios/Localization/en.lproj -o ios/FluentUI/Resources/Localization
scripts/GetLocalizedFiles.sh -t $teamId -u -a $alias -p $password -f macos/FluentUIResources-macos/Strings/en.lproj -r macos/Localization/en.lproj -o macos/FluentUIResources-macos/Strings
