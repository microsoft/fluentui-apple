//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ButtonDemoControllerSwiftUI: FluentThemedHostingController {
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: AnyView(ButtonDemoView()))
        self.title = "Button (SwiftUI)"
    }

    @MainActor required dynamic init(rootView: AnyView) {
        super.init(rootView: rootView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearanceAndReadmePopovers()
    }

    // MARK: - Demo Appearance Popover

    func configureAppearanceAndReadmePopovers() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "ic_fluent_settings_24_regular"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showAppearancePopover(_:)))
        navigationItem.rightBarButtonItems = [settingsButton]
    }

    @objc func showAppearancePopover(_ sender: AnyObject, presenter: UIViewController) {
        if let barButtonItem = sender as? UIBarButtonItem {
            appearanceController.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let sourceView = sender as? UIView {
            appearanceController.popoverPresentationController?.sourceView = sourceView
            appearanceController.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        appearanceController.popoverPresentationController?.delegate = self
        presenter.present(appearanceController, animated: true, completion: nil)
    }

    @objc func showAppearancePopover(_ sender: AnyObject) {
        showAppearancePopover(sender, presenter: self)
    }

    private lazy var appearanceController: DemoAppearanceController = .init(delegate: self as? DemoAppearanceDelegate)

}

extension ButtonDemoControllerSwiftUI: UIPopoverPresentationControllerDelegate {
    /// Overridden to allow for popover-style modal presentation on compact (e.g. iPhone) devices.
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

struct ButtonDemoView: View {
    public var body: some View {
        VStack {
            if showToggle {
                demoToggle(size, isDisabled: isDisabled)
            } else {
                demoButton(style, size, isDisabled: isDisabled)
            }
            demoOptions
        }
    }

    @State var isDisabled: Bool = false
    @State var text: String = "Button"
    @State var showImage: Bool = true
    @State var showLabel: Bool = true
    @State var showAlert: Bool = false
    @State var size: ControlSize = .large
    @State var style: FluentUI.ButtonStyle = .accent
    @State var showToggle: Bool = false

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    @State var isToggleOn: Bool = false

    @ViewBuilder
    private var buttonLabel: some View {
        HStack {
            if showImage {
                Image("Placeholder_24")
            }
            if showLabel && text.count > 0 {
                Text(text)
            }
        }
    }

    @ViewBuilder
    private func demoButton(_ buttonStyle: FluentUI.ButtonStyle, _ controlSize: ControlSize, isDisabled: Bool) -> some View {
        Button(action: {
            showAlert = true
        }, label: {
            buttonLabel
        })
        .buttonStyle(FluentButtonStyle(style: buttonStyle))
        .controlSize(controlSize)
        .disabled(isDisabled)
        .fixedSize()
        .padding(GlobalTokens.spacing(.size80))
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Button tapped"))
        })
    }

    @ViewBuilder
    private func demoToggle(_ controlSize: ControlSize, isDisabled: Bool) -> some View {
        Toggle(isOn: $isToggleOn, label: {
            buttonLabel
        })
        .toggleStyle(FluentButtonToggleStyle())
        .controlSize(controlSize)
        .disabled(isDisabled)
        .fixedSize()
        .padding(GlobalTokens.spacing(.size80))
    }

    @ViewBuilder
    private var demoOptions: some View {
        Form {
            Section("Content") {
                HStack(alignment: .firstTextBaseline) {
                    Text("Button Text")
                    Spacer()
                    TextField("Text", text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity)

                FluentUIDemoToggle(titleKey: "Show image", isOn: $showImage)
                FluentUIDemoToggle(titleKey: "Show label", isOn: $showLabel)
                FluentUIDemoToggle(titleKey: "Disabled", isOn: $isDisabled)
            }

            Section("Style and Size") {
                FluentUIDemoToggle(titleKey: "Present as toggle", isOn: $showToggle)
                if !showToggle {
                    Picker("Style", selection: $style) {
                        ForEach(Array(FluentUI.ButtonStyle.allCases.enumerated()), id: \.element) { _, buttonStyle in
                            Text("\(buttonStyle.description)").tag(buttonStyle.rawValue)
                        }
                    }
                }

                Picker("Control Size", selection: $size) {
                    ForEach(Array(SwiftUI.ControlSize.allCases.enumerated()), id: \.element) { _, buttonSize in
                        Text("\(buttonSize.description)").tag(buttonSize)
                    }
                }
            }

            Section("More") {
                NavigationLink("All Button Styles") {
                    allButtonStyles
                }
            }
        }
    }

    @ViewBuilder
    private var allButtonStyles: some View {
        ScrollView {
            ForEach(Array(FluentUI.ButtonStyle.allCases.enumerated()), id: \.element) { _, buttonStyle in
                Text("\(buttonStyle.description)")
                    .font(Font(fluentTheme.typography(.title2)))
                ForEach(Array([ControlSize.small, ControlSize.regular, ControlSize.large].enumerated()), id: \.element) { _, controlSize in
                    HStack {
                        demoButton(buttonStyle, controlSize, isDisabled: false)
                        demoButton(buttonStyle, controlSize, isDisabled: true)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

private extension ControlSize {
    var description: String {
        switch self {
        case .mini:
            return "mini"
        case .small:
            return "small"
        case .regular:
            return "regular"
        case .large:
            return "large"
        case .extraLarge:
            return "extraLarge"
        @unknown default:
            return "UNKNOWN"
        }
    }
}
