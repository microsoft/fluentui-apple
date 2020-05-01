# Fluent UI for iOS

##### The iOS UI framework for building experiences for Microsoft 365.

FluentUI for iOS is a native library that provides the Microsoft UI experience for the iOS platform. It contains information about colors and typography, as well as custom controls and customizations for platform controls, all from the official Fluent design language used in Microsoft 365 products.

## Contents

- [Colors and typography](#colors-and-typography)
- [Controls](#controls)
- [Install and use FluentUI](#install-and-use-fluentui)
- [Demo app](#demo-app)

## Colors and Typography

FluentUI for iOS provides [colors](FluentUI/Core/Colors.swift) and [typography](FluentUI/Core/Fonts.swift) core to experiences within the Fluent Design language.

## Controls

FluentUI for iOS includes an expanding library of controls written in Swift and supporting Objective-C. These controls implement the Fluent Design language and provide consistency across Microsoft experiences.

Some of the controls available include:
- ActivityIndicatorView
- AvatarView
- BadgeView
- Button
- DateTimePicker
- DrawerController
- HUD
- Label
- NavigationController
- NotificationView
- PersonaListView
- PillButtonBar
- PopupMenuController
- SegmentedControl
- ShimmerLinesView
- TabBarView
- TableViewCell
- Tooltip

A full list of currently supported controls can be found here: [FluentUI](FluentUI).

## Demo app

Included in this repository is a demo of currently implemented controls. A full list of implemented controls available in the demo can be found here:  [Demos](FluentUI.Demo/FluentUI.Demo/Demos).

To build and deploy the demo follow these steps:
- Download or clone the [FluentUI for iOS](https://github.com/microsoft/fluentui-apple) repository.
- Open `ios/FluentUI.xcworkspace` in Xcode.
- In the Xcode scheme menu choose `Demo.development` and choose a device to deploy to.
- Once deployed you can choose a control to demo from the list of controls on the selected device.
