### Platforms Impacted
- [ ] iOS
- [ ] visionOS
- [ ] macOS

### Description of changes

(a summary of the changes made, often organized by file)

### Binary change

(how is our binary size impacted -- see https://github.com/microsoft/fluentui-apple/wiki/Size-Comparison)

### Verification

(how the change was tested, including both manual and automated tests)

<details>
<summary>Visual Verification</summary>

| Before                                       | After                                      |
|----------------------------------------------|--------------------------------------------|
| Screenshot or description before this change | Screenshot or description with this change |
</details>

### Pull request checklist

This PR has considered:
- [ ] Light and Dark appearances
- [ ] iOS supported versions (all major versions greater than or equal current target deployment version)
- [ ] VoiceOver and Keyboard Accessibility
- [ ] Internationalization and Right to Left layouts
- [ ] Different resolutions (1x, 2x, 3x)
- [ ] Size classes and window sizes (iPhone vs iPad, notched devices, multitasking, different window sizes, etc)
- [ ] iPad [Pointer interaction](https://developer.apple.com/documentation/uikit/pointer_interactions)
- [ ] [SwiftUI](https://developer.apple.com/tutorials/swiftui) consumption (validation or new demo scenarios needed)
- [ ] Objective-C exposure (provide it only if needed)