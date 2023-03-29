#!/bin/bash

#simple script used to create PRs for the automated localization process

newBranch="tdbuild`date +%s`"

if [[ `git status --porcelain` ]]; then
  echo "Pushing new localization changes"
  git config --global user.email $EMAIL
  git config --global user.name $NAME
  git add .
  git commit -m 'Latest localized resource files from Touchdown Build'
  git checkout -b $newBranch
  git push --set-upstream origin $newBranch
  gh pr create -B main -H $newBranch --title '[Localization] Localized Resource Files' --body  'Latest localized resource files from Touchdown Build' -l 'Automated PR'
else
  echo "No changes found"
fi