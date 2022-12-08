### Platforms Impacted
- [ ] iOS
- [ ] macOS

### Description of changes

Binary change:
<!---
Please fill in the table below with the binary size of files changed from the latest 
state of the branch you are merging into and the latest state of your changes. In 
order to get an accurate measurement of our framework, follow these instructions:
  1. Change scheme to Demo.Release for Any iOS Device (arm64).
  2. Build, then navigate to left panel: FluentUI -> Products -> libFluentUI.a
  3. Show file in Finder, Get Info, & record libFluentUI.a binary size.

For individual files:
  1. Prepare a new folder anywhere outside of the FluentUI git repo. The following 
     .o files will be generated here. Open terminal & navigate to your new folder.
  2. Type "ar x <path of libFluentUI.a>" (no quotes or brackets).
  3. Find your modified .o files in your folder, Get Info, & record binary size.

NOTE: These generated files should not be a part of the PR.
--->
| File | Before | After | Delta |
|------|--------|-------|-------|
| libFluentUI.a |  |  |  |
|  |  |  |  |

(a summary of the changes made, often organized by file)

### Verification

(how the change was tested, including both manual and automated tests)

| Before                                       | After                                      |
|----------------------------------------------|--------------------------------------------|
| Screenshot or description before this change | Screenshot or description with this change |

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