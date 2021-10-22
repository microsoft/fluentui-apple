# Fluent UI Apple
Fluent UI Apple contains native UIKit and AppKit controls aligned with [Microsoft's Fluent UI design system](https://www.microsoft.com/design/fluent/#/). 

![Build Status](https://github.com/microsoft/fluentui-apple/workflows/CI/badge.svg?branch=main)
![Localization Status](https://github.com/microsoft/fluentui-apple/workflows/Localize/badge.svg)
![CocoaPod Publishing](https://github.com/microsoft/fluentui-apple/workflows/Pod-Publish/badge.svg)
[![Build Status](https://dev.azure.com/microsoftdesign/fluentui-native/_apis/build/status/microsoft.fluentui-apple?branchName=main)](https://dev.azure.com/microsoftdesign/fluentui-native/_build/latest?definitionId=144&branchName=main)
![License](https://img.shields.io/github/license/Microsoft/fluentui-apple)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MicrosoftFluentUI)](https://cocoapods.org/pods/MicrosoftFluentUI)
![Platform](https://img.shields.io/cocoapods/p/MicrosoftFluentUI.svg?style=flat)

## Getting Started
### Install and use FluentUI

#### Requirements

- iOS 13+ or macOS 10.14+
- Xcode 13+
- Swift 5.4+

#### Using Carthage

To integrate FluentUI using Carthage, specify it in your Cartfile:

```
github "Microsoft/fluentui-apple" ~> X.X.X
```

then follow the Carthage [integration steps](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the `FluentUI.framework` into your Xcode project

#### Using CocoaPods

To get set up with CocoaPods visit their [getting started guide](https://guides.cocoapods.org/using/getting-started.html).

To integrate FluentUI into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby
pod 'MicrosoftFluentUI', '~> X.X.X'
```

#### Manual installation

- Download the latest changes from the [FluentUI for Apple](https://github.com/microsoft/fluentui-apple) repository.
- Move the `fluentui-apple` folder into your project folder.
- Move the relevant `FluentUI.xcodeproj` into your Xcode project depending on which platform you want to support.
- In Xcode select your project -> your target -> General -> Embedded Binaries -> add `FluentUI.framework`.

#### Swift Package Manager
As of this writing, the version of Swift Package Manager shipped with the latest Xcode does not support packages that require resource bundles. As Fluent UI Apple does  require resource bundles, we do not currently support Swift Package Manager.

### Import and use FluentUI

After the framework has been added you can import the module to use it:

For Swift
```swift
import FluentUI
```
For Objective-C
```objective-c
#import <FluentUI/FluentUI.h>
```

## Contributing

Post bug reports, feature requests, and questions in [Issues](https://github.com/microsoft/fluentui-apple/issues).

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

### CocoaPods Setup

If you are using Apple Silicon M1 machine then you need to install `ffi` in addition to CocoaPods. More details about the issue can be found [here](https://github.com/ffi/ffi/issues/870).

```bash
sudo arch -x86_64 gem install ffi
```

To execute any pod command on M1 machine you need to specify the architecture of the machine explicitly

```bash
arch -x86_64 pod lib lint
```

### Developing in the repo

Fluent UI Apple requires all [pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) to come from forks of the repository. Please see [Fork a Repo - GitHub Help](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) for more details on how to set up a fork of Microsoft/fluentui-apple, keep it up-to-date, and submit pull requests back to this repository.

Fluent UI Apple doesn't have any external code dependencies, so developing in the repository is as easy as launching the appropriate Xcode project or workspace and building and running a test app.

For more platform-specific information, please see [the iOS readme file](ios/README.md) and the [the macOS readme file](macos/README.md).

#### Swift Lint
This project uses [SwiftLint](https://github.com/realm/SwiftLint) to automatically lint our Swift code for common errors. Please install it when developing in this repo by following the [SwiftLint Installation Instructions](https://realm.github.io/SwiftLint/).

## Changelog

We use [GitHub Releases](https://github.com/blog/1547-release-your-software) to manage our releases, including the changelog between every release. You'll find a complete list of additions, fixes, and changes on the [Releases page](https://github.com/microsoft/fluentui-apple/releases).

## License

All files on the FluentUI Apple GitHub repository are subject to the MIT license. Please read the [LICENSE](LICENSE) file at the root of the project.

Usage of the logos and icons referenced in FluentUI Apple is subject to the terms of the [assets license agreement](https://aka.ms/fabric-assets-license).
