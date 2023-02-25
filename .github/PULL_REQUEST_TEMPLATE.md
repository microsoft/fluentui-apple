### Platforms Impacted
- [ ] iOS
- [ ] macOS

### Description of changes

Binary change:
<!---
These steps are for iOS. Feel free to skip on Mac.
Please include the output of scripts/GenerateBinaryDiffTable.swift, using the following steps:
  1. Ensure that your working branch is up to date with the base branch.
  2. Build the base branch Demo.Release scheme for Any iOS Device (arm64)
  3. Navigate to left panel: FluentUI -> Products -> libFluentUI.a
  4. Show libFluentUI.a in Finder, and copy libFluentUI.a to a safe location for use later.
    a. <Optional> Also grab FluentUI.Demo while you're there, and likewise move it somewhere safe.
  5. Switch to your working branch and repeat steps 2-4.
  6. Now that you have both your old and new builds, you can run the script. From the root of this repo, 
     you can run `swift ./scripts/GenerateBinaryDiffTable.swift <path to old build> <path to new build>`.
     This will generate a table that compares any changes in .o files between the two builds.
  7. Copy the output of the script to this PR.
  8. <Optional> The default output will only show the total changes outside of the summary,
                but you might want to include any especially relevant or noteworthy changes
                in the initial table.
  9. <Optional> Another delta worth showing in the initial table comes from the demo app.
             a. Navigate to FluentUI.Demo that you saved in before steps 4.a, right click,
                and select "Show package contents"
             b. Find the FluentUI.Demo inside FluentUI.Demo, right click, and select "Get Info"
             c. Create a new row in the initial table, titled "unstripped FluentUI.Demo/FluentUI.Demo",
                and paste this value into the "Before" column.
             d. Run ` /usr/bin/strip -Sx <path to FluentUI.Demo/FluentUI.Demo>`
             e. Create a new row in the initial table, titled "stripped FluentUI.Demo/FluentUI.Demo",
                and paste this value into the "Before" column.
             f. Repeat steps a-e for the after build.
             g. Calculate the difference between the before and after builds, and put them in the "Delta" column.
--->

(a summary of the changes made, often organized by file)

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