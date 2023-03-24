#!/bin/bash

#simple script used to create PRs for the automated localization process

timestamp=$(<$1)

git checkout -b 'tdbuild$timestamp'
git push --set-upstream origin tdbuild$timestamp
gh pr create -B main -H tdbuild$timestamp --title '[Localization] Localized Resource Files' --body  'Latest localized resource files from Touchdown Build' -l 'Automated PR'
