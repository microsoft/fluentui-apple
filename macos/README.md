# Fluent UI for macOS

##### The macOS UI framework for building experiences for Microsoft 365.

FluentUI for macOS is a native framework that provides the Microsoft UI experience for the macOS platform. It contains custom controls and customizations for platform controls, all from the official Fluent design language used in Microsoft 365 products.

## Contents

- [Controls](#controls)
- [Demo app](#demo-app)

## Controls

FluentUI for macOS includes an expanding set controls written in Swift and supporting Objective-C. These controls implement the Fluent Design language and provide consistency across Microsoft experiences.

A full list of currently supported controls can be found here: [FluentUI](FluentUI).

## Demo app

Included in this repository is a demo of currently implemented controls. A full list of implemented controls available in the demo can be found here: [Demos](FluentUITestApp).

To build and run the demo app follow these steps:
- Download or clone the [FluentUI](https://github.com/microsoft/fluentui-apple) repository.
- Open `macos/xcode/FluentUI.xcodeproj` in Xcode.
- In the Xcode scheme menu choose `FluentUITestApp` and choose "My Mac" as the deployment target.
- Once deployed you can choose a control to test from the list of controls in the left pane.
