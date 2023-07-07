# Navigation

## Overview

Use a `NavigationController` to enable users to navigate through hierarchical data. `NavigationController`, along with [extensions to `UINavigationItem`](https://github.com/microsoft/fluentui-apple/blob/main/ios/FluentUI/Navigation/UINavigationItem%2BNavigation.swift), allow you to render all relevant information with a Fluent look and feel.

## Notes on Bar Height

By default, iOS can show navigation bars in one of two different appearances: regular and compact, with heights of 44px and 32px respectively. The compact appearance is reserved for "small" iPhones (e.g., the iPhone 14 or iPhone 14 Pro) held horizontally.

Due to its reduced footprint, the compact navigation bar doesn't play nicely with larger or two-line title views. Therefore, we always enforce a 44px-tall bar whenever we detract from a system-style title. In cases where a compact appearance style will do, we provide an optional parameter `forcesCompactBarExpansion` to the initializer of `NavigationController`. This value is set to `false` by default.

This value should be to `true` for the root navigation controller, which usually displays more information. It should be left as `false` for any navigation-enabled sheets or dialogs the app spawns, since these will generally have simpler hierarchies.

## Examples

### Basic Appearance

| `NavigationBar.Style` | Example |
|-|-|
| `.primary` | ![Navigation-Style-Primary.png](.attachments/Navigation-Style-Primary.png) |
| `.system` | ![Navigation-Style-System.png](.attachments/Navigation-Style-System.png) |
| `.custom` | ![Navigation-Style-Custom.png](.attachments/Navigation-Style-Custom.png) |

| `NavigationBar.TitleStyle` | Example |
|-|-|
| `.system` | ![Navigation-TitleStyle-System1.png](.attachments/Navigation-TitleStyle-System1.png) ![Navigation-TitleStyle-System2.png](.attachments/Navigation-TitleStyle-System2.png) |
| `.leading` | ![Navigation-TitleStyle-Leading1.png](.attachments/Navigation-TitleStyle-Leading1.png) ![Navigation-TitleStyle-Leading2.png](.attachments/Navigation-TitleStyle-Leading2.png) |
| `.largeLeading` | ![Navigation-Style-Primary.png](.attachments/Navigation-Style-Primary.png) |

### More Customization Options

By specifying an appropriate instance of `NavigationBarTitleAccessory`, you can indicate to users that the title can be pressed.

You can also specify an optional `titleImage` with the associated navigation item.

| Specifications | Example |
|-|-|
| Title down arrow with `titleImage` | ![Navigation-Accessory-Image-TitleDownArrow.png](.attachments/Navigation-Accessory-Image-TitleDownArrow.png)
| Subtitle disclosure | ![Navigation-Accessory-SubtitleDisclosure.png](.attachments/Navigation-Accessory-SubtitleDisclosure.png)

## Implementation

### Source Code

[Navigation folder](https://github.com/microsoft/fluentui-apple/blob/main/ios/FluentUI/Navigation/)

### Sample Code

[NavigationControllerDemoController.swift](https://github.com/microsoft/fluentui-apple/blob/main/ios/FluentUI.Demo/FluentUI.Demo/Demos/NavigationControllerDemoController.swift)
