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

scripts/GetLocalizedFiles.sh -t $teamId -u -a $alias -p $password -f ios/FluentUI/Resources/Localization/en.lproj/Localizable.strings -r ios/FluentUI/Resources/Localization/en.lproj/Localizable.strings -o ios/FluentUI/Resources/Localization
