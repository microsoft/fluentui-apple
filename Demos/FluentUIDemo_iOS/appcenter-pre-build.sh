#!/usr/bin/env bash

echo 'Replacing AppCenterSecret placeholder...'
sed -i '' -e "s/$AppCenterSecretPlaceHolder/\"$AppCenterSecret\"/g" ./FluentUI.Demo/FluentUI.Demo/AppDelegate.swift
