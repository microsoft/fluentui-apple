# Navigation

## Overview

Use a `NavigationController` to enable users to navigate through hierarchical data. `NavigationController`, along with [extensions to `UINavigationItem`](https://github.com/microsoft/fluentui-apple/blob/main/ios/FluentUI/Navigation/UINavigationItem%2BNavigation.swift), allow you to render all relevant information with a Fluent look and feel.

### Appearance Examples

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
