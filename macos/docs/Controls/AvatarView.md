# AvatarView

## Overview
`AvatarView` is a visual representation of a user, entity, or group. If an image is supplied, it is cropped to a circle of the requested size. If an image is not supplied, initials are extracted from the given name and email address provided and displayed on a colorful background.

To determine initials for an avatar, the code initially tries to extract two-letter initials from `contactName`. If that isn't successful, it falls back to trying the first initial of the `contactEmail`. If the algorithm fails to extract a character from the `contactEmail`, it falls back to the `#` character to represent the generic user.

![AvatarViews.png](.attachments/AvatarViews.png)

## Best Practices
### Do
- Use `AvatarView` to visually represent a user or entity in your product.
- Use an image if available.

### Don't
- Don't omit information about a user that is available, as all of the information (including email) is used to provide a unique and consistent color for the user.

## Usage
```Swift
// With an image
AvatarView(avatarSize: size,
           contactName: "Annie Lindqvist",
           contactEmail: "Annie.Lindqvist@example.com",
           contactImage: NSImage(named: "annie"))
```
![AvatarViewImage.png](.attachments/AvatarViewImage.png)

```Swift
// Without an image
AvatarView(avatarSize: size,
           contactName: "Annie Lindqvist",
           contactEmail: "Annie.Lindqvist@example.com",
           contactImage: nil)
```
![AvatarViewInitials.png](.attachments/AvatarViewInitials.png)

## Implementation
### Control Name
`AvatarView` in Swift, `MSFAvatarView` in Objective-C
### Source Code
[AvatarView.swift](https://github.com/microsoft/fluentui-apple/blob/master/macos/FluentUI/AvatarView.swift)
### Sample Code
[TestAvatarViewController.swift](https://github.com/microsoft/fluentui-apple/blob/master/macos/FluentUITestApp/TestAvatarViewController.swift)
