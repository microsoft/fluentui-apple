# Label
## Overview
Use `Label` to standardize text across your app.
The different styles and colors of `Label` are pictured below. 
![Label.png](.attachments/Label.png)

## Usage
### UIKit
```Swift
        let label = Label(style: style, colorStyle: colorStyle)
        label.text = text
        label.numberOfLines = 0
```
### SwiftUI
There is currently no SwiftUI implementation of the Label

## Implementation
### Control Name
`Label` in Swift, `MSFLabel` in Objective-C
### Source Code
[Label.swift](https://github.com/microsoft/fluentui-apple/blob/main/ios/FluentUI/Label/Label.swift)
### Sample Code
[LabelDemoController.swift](https://github.com/microsoft/fluentui-apple/blob/fluent2-tokens/ios/FluentUI.Demo/FluentUI.Demo/Demos/LabelDemoController.swift)
