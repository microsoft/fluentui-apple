# Navigation

## Overview

FluentUI introduces the `NavigationBar` and `NavigationController` classes as Fluent-specific subclasses of their UIKit counterparts, [`UINavigationBar`](https://developer.apple.com/documentation/uikit/uinavigationbar) and [`UINavigationController`](https://developer.apple.com/documentation/uikit/uinavigationcontroller) respectively. These classes will handle rendering all the relevant information with a Fluent look and feel. This means that you can tell your app to use the Fluent `NavigationController` (which already knows to use the Fluent `NavigationBar` by default) and everything will "just work."

Similar to UIKit, most of the logic for what a `NavigationBar` should display comes from `UINavigationItem` instances. FluentUI [extends this class](../../FluentUI/Navigation/UINavigationItem%2BNavigation.swift) to include new features, such as appearance, interactivity, and subtitles.

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

[Navigation folder](../../FluentUI/Navigation/)

### Sample Code

[NavigationControllerDemoController.swift](../../FluentUI.Demo/FluentUI.Demo/Demos/NavigationControllerDemoController.swift)
