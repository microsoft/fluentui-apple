# Fluent UI for macOS

## Demo app

Included in this repository is a demo that showcases all the currently available Fluent macOS controls.

To build and deploy the demo follow these steps:
- clone the [FluentUI](https://github.com/microsoft/fluentui-apple) repository.
- Open `macos/xcode/FluentUI.xcodeproj` in Xcode.
- In the Xcode scheme menu choose `FluentUITestApp-macOS` and choose "My Mac" as the deployment target.
- Once deployed you can choose a control to test from the list of controls in the left pane.

### Adding a new component
- Create a new folder of the Control name (ex. Foo) under [FluentUI](FluentUI)
- Create a new swift file. (ex. Foo.swift)
- Add Foo.swift and its folder in FluentUI xcode project (All the files are in alphabetical order)
- Make sure your file is under FluentUI framework target
- Create and add a test ViewController under [FluentUITestViewControllers](FluentUITestViewControllers) (ex. TestFooViewController.swift)
- Add TestFooViewController.swift to FluentUI xcode project (All the files are in alphabetical order)
- Make sure it is part of FluentUITestViewControllers Target membership
- Add TestFooViewController to the array in [TestViewContronllers.swift](https://github.com/microsoft/fluentui-apple/blob/02b1c3fe601b793cb6cfd24813e11d92420e0d77/macos/FluentUITestViewControllers/TestViewControllers.swift#L14)
- Add a new cocopod subspec in [MicrosoftFluentUI.podspec](https://github.com/microsoft/fluentui-apple/blob/main/MicrosoftFluentUI.podspec) with required dependencies. "s.subspec 'Foo_mac' do |foo_mac|"
- Verify by "pod spec lint" For more info on [cocoapod](https://cocoapods.org)
- Build and Run
- Make sure no warnings and errors. Test your components!
- Add documentation for your new class and especially for public apis
- Add Unit Test for FluentUITests framework

## Checklist before creating a pull request
Fill out all the information in your [PR description](https://github.com/microsoft/fluentui-apple/blob/main/.github/PULL_REQUEST_TEMPLATE.md#pull-request-checklist)

Once your pull request has been approved by @microsoft/fluentui-native team, if you have the write access you can squash-merge your changes or @microsoft/fluentui-native team member will merge it for you.
