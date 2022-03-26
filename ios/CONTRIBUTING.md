# Fluent UI for macOS

## Demo app

Included in this repository is a demo of currently implemented controls.

To build and run the demo app follow these steps:
- Clone the [FluentUI](https://github.com/microsoft/fluentui-apple) repository.
- Open `ios/FluentUI.xcworkspace` in Xcode.
- In the Xcode scheme menu choose `Demo.development` and choose an iOS Simulator(or Device if you have your own device provisioning profile) to deploy to.
- Make sure Swift Package Manager has download 2 dependencies(appcenter-sdk-apple and PLCrashReporter) for demo app.
- Build and Run the demo app

## Adding a new component
- Create a new folder of the Control name (ex. Foo) under under [FluentUI](FluentUI)
- Create a new swift file. (ex. Foo.swift)
- Add Foo.swift in Fluent xcode project (All the files are in alphabetical order)
- Make sure your file is under FluentUILib target
- Create and add a demo controller in the Fluent demo app under [Demos](FluentUI.Demo/FluentUI.Demo/Demos) (ex.FooDemoController.swift)
- Add FooDemoController to Fluent Demo xcode project (All the files are in alphabetical order)
- Make sure its part of FluentUI.Demo Target membership
- Add your FooDemoController in list of [DemoDescriptor](https://github.com/microsoft/fluentui-apple/blob/02b1c3fe601b793cb6cfd24813e11d92420e0d77/ios/FluentUI.Demo/FluentUI.Demo/Demos.swift#L30)
- Add a new cocopod subspec in [MicrosoftFluentUI.podspec](https://github.com/microsoft/fluentui-apple/blob/main/MicrosoftFluentUI.podspec) with required dependencies. "s.subspec 'Foo_ios' do |foo_ios|"
- Verify by "pod spec lint" For more info on [cocoapod](https://cocoapods.org)
- Build and Run
- Make sure no warnings and errors
- Add documentation for your new class and especially for public apis
- Add Unit Test for FluentUITests framework

## Checklist before creating a pull request
Fill out all the information in your [PR description](https://github.com/microsoft/fluentui-apple/blob/main/.github/PULL_REQUEST_TEMPLATE.md#pull-request-checklist)

Once your pull request has been approved by @microsoft/fluentui-native team, if you have the write access you can squash-merge your changes or @microsoft/fluentui-native team member will merge it for you.
