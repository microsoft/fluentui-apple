# [Control Name]

## Overview
`BadgeView` is used to display short colored text over a colored background

![BadgeView.png](.attachments/Badge.png)

## Best Practices
### Do
- Use `BadgeView` to display short strings

### Don't
- Use `BadgeView` to display long strings that risk taking multiple lines

## Usage
```Swift
BadgeView(title: "Badge")
```

## Implementation
### Control Name
`BadgeView` in Swift, `MSFBadgeView` in Objective-C
### Source Code
[BadgeView.swift](https://github.com/microsoft/fluentui-apple/blob/main/macos/FluentUI/BadgeView/BadgeView.swift)
### Sample Code
[TestBadgeViewController.swift](https://github.com/microsoft/fluentui-apple/blob/main/macos/FluentUITestViewControllers/TestBadgeViewController.swift)
