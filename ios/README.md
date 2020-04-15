# Fluent UI for iOS

##### The iOS UI framework for building experiences for Office and Office 365.

Office UI Fabric for iOS is a native library that provides the Office UI experience for the iOS platform. It contains information about colors and typography, as well as custom controls and customizations for platform controls, all from the official Fluent design language used in Office and Office 365 products.

## Contents

- [Colors and typography](#colors-and-typography)
- [Controls](#controls)
- [Install and use Office UI Fabric](#install-and-use-office-ui-fabric)
- [Demo app](#demo-app)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

## Colors and Typography

Office UI Fabric for iOS provides [colors](FluentUI/Core/Colors.swift) and [typography](FluentUI/Core/Fonts.swift) core to experiences within the Fluent Design language.

## Controls

Office UI Fabric for iOS includes an expanding library of controls written in Swift and supporting Objective-C. These controls implement the Fluent Design language and provide consistency across Office experiences.

Some of the controls available include:
- MSActivityIndicatorView
- MSAvatarView
- MSBadgeView
- MSButton
- MSDateTimePicker
- MSDrawerController
- MSHUD
- MSLabel
- MSPersonaListView
- MSPopupMenuController
- MSSegmentedControl
- MSTableViewCell

A full list of currently supported controls can be found here: [OfficeUIFabric](OfficeUIFabric).

## Install and use Office UI Fabric

### Requirements

- iOS 11+
- Xcode 11+
- Swift 5.0+

### 1. Using CocoaPods

To get set up with CocoaPods visit their [getting started guide](https://guides.cocoapods.org/using/getting-started.html).

To integrate Office UI Fabric for iOS into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby
pod 'FluentUI', '~> 0.1.0'
```

### 2. Using Carthage

To integrate Office UI Fabric using Carthage, specify it in your Cartfile:

```ruby
github "Microsoft/fluentui-apple" ~> 0.1.0
```

then follow the Carthage [integration steps](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the `FluentUI.framework` into your XCode project

### 3. Manual installation

- Download the latest changes from the [FluentUI for iOS](https://github.com/microsoft/fluentui-apple) repository.
- Move the `FluentUI` folder into your project folder.
- Move the `FluentUI.xcodeproj` into your Xcode project.
- In Xcode select your project -> your target -> General -> Embedded Binaries -> add `FluentUI.framework`.

### Import and use the library

After the framework has been added you can import the library to use it:
```swift
import FluentUI
```

## Demo app

Included in this repository is a demo of currently implemented controls. A full list of implemented controls available in the demo can be found here:  [Demos](FluentUI.Demo/FluentUI.Demo/Demos).

To build and deploy the demo follow these steps:
- Download or clone the [FluentUI for iOS](https://github.com/microsoft/fluentui-apple) repository.
- Open `FluentUI.xcworkspace` in Xcode.
- In the Xcode scheme menu choose `Demo.development` and choose a device to deploy to.
- Once deployed you can choose a control to demo from the list of controls on the selected device.

## Contributing

Post bug reports, feature requests, and questions in [Issues](https://github.com/microsoft/fluentui-apple/issues).

## Changelog

We use [GitHub Releases](https://github.com/blog/1547-release-your-software) to manage our releases, including the changelog between every release. You'll find a complete list of additions, fixes, and changes on the [Releases page](https://github.com/microsoft/fluentui-apple/releases).

## License

All files on the Office UI Fabric for iOS GitHub repository are subject to the MIT license. Please read the [LICENSE](LICENSE) file at the root of the project.

Usage of the logos and icons referenced in FluentUI for iOS is subject to the terms of the [assets license agreement](https://aka.ms/fabric-assets-license).
