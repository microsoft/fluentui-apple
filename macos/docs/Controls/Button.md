# Button

## Overview
Buttons are one of the core controls that make an app feel native to the platform it's on. It’s important to respect the platform's paradigms in order to help the user feel at home on macOS and keep the experience quality high.

![ButtonViews.png](.attachments/ButtonViews.png)

## Best Practices
### Do
- Make sure the label conveys a clear purpose of the button to the user.
- Describe the action the button will perform, ideally with a verb. Use concise, specific, self-explanatory labels, usually a single word.

### Don't
- Place the default focus on a button that performs a destructive actionn. Instead, place the default focus on the button that performs the "safe action" (e.g "Cancel").

## Usage
```Swift
// There are 3 styles to choose from, the default being primary filled
let primaryFilledButton = Button(title: "FluentUI Button", style: .primaryFilled),
let primaryOutlineButton = Button(title: "FluentUI Button", style: .primaryOutline),
let borderlessButton = Button(title: "FluentUI Button", style: .borderless)
```

```Swift
// You can display an image instead of a title
let buttonWithImageAndStyle = Button(image: NSImage(named: NSImage.addTemplateName)!, style: .primaryFilled)
```


## Implementation
### Control Name
`Button` in Swift, `MSFButton` in Objective-C
### Source Code
[Button.swift](https://github.com/microsoft/fluentui-apple/blob/master/macos/FluentUI/Button.swift)
### Sample Code
[TestButtonViewController.swift](https://github.com/microsoft/fluentui-apple/blob/master/macos/FluentUITestApp/TestButtonViewController.swift)