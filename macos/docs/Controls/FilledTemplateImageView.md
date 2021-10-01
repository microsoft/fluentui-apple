# FilledTemplateImageView

## Overview
`FilledTemplateImageView` is an image view used for displaying templated style images/icons and filling them with a specified color. This is accomplished by taking in two images of identical size, one that represents the outline (the main templated style "image") and a corresponding overlay "fillMask" that is used for drawing the fill. After the image is created the first time, the image set and the "fillColor" and "borderColor" can be updated via properties to provide dymamic updating. The fill can also be set to "NSColor.clear" to prevent it from being filled using the fillMask.

![FilledTemplate-redFill-whiteBorder.png](.attachments/FilledTemplate-redFill-whiteBorder.png)

## Best Practices
### Do
- Use `FilledTemplateImageView` for template style images that have a large enough "fill-able" area to achieve a high quality look.
- Provide proper image and mask sets where the images line up pixel perfect.
- Use for images where the fill area needs to change dymamically, vs. just static style images.
- To achieve no fill, use NSColor.clear as the color.

### Don't
- Use for images that don't make sense to fill dynamically.
- Use for images that are too small in size to reasonably fill.

## Usage
```Swift
// Create an image with black outline and blue fill...
let tagImage = FilledTemplateImageView(image: tagIcon,
                                       fillMask: tagFillIcon,
                                       borderColor: .black, 
                                       fillColor: .blue)
```
![FilledTemplate-blueFill-blackBorder.png](.attachments/FilledTemplate-blueFill-blackBorder.png)

```Swift
// To change the above to remove the fill and give it a white border...
tagImage.borderColor = .white
tagImage.fillColor = .clear
```
![FilledTemplate-clearFill-whiteBorder.png](.attachments/FilledTemplate-clearFill-whiteBorder.png)

## Implementation
### Control Name
`FilledTemplateImageView` in Swift, `MSFFilledTemplateImageView` in Objective-C
### Source Code
[FilledTemplateImageView.swift](https://github.com/microsoft/fluentui-apple/blob/main/macos/FluentUI/FilledTemplateImageView/FilledTemplateImageView.swift)
### Sample Code
[FilledTemplateImageViewController.swift](https://github.com/microsoft/fluentui-apple/blob/main/macos/FluentUITestViewControllers/FilledTemplateImageViewController.swift)
