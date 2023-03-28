#!/bin/bash

#simple script used to create PRs for the automated localization process

newBranch="tdbuild`date +%s`"

git checkout -b $newBranch
git push --set-upstream origin $newBranch
gh pr create -B main -H $newBranch --title '[Localization] Localized Resource Files' --body  'Latest localized resource files from Touchdown Build' -l 'Automated PR'
