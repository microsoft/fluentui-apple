//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ButtonDemoControllerSwiftUI: FluentUIHostingController {
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
    @State var isDisabled: Bool = false
    @State var text: String = "Button"
    @State var showImage: Bool = true
    @State var showLabel: Bool = true
    @State var showAlert: Bool = false
    @State var size: FluentUI.ButtonSizeCategory = .large
    @State var style: FluentUI.ButtonStyle = .accent

    public var body: some View {
        VStack {
            demoButton
            demoOptions
        }
    }

    @ViewBuilder
    private var demoButton: some View {
        Button(action: {
            showAlert = true
        }, label: {
            HStack {
                if showImage {
                    Image("Placeholder_24")
                }
                if showLabel && text.count > 0 {
                    Text(text)
                }
            }
        })
        .buttonStyle(FluentButtonStyle(style: style, size: size))
        .disabled(isDisabled)
        .fixedSize()
        .padding()
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Button tapped"))
        })
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

            Section("Style") {
                Picker("Style", selection: $style) {
                    ForEach(Array(FluentUI.ButtonStyle.allCases.enumerated()), id: \.element) { _, buttonStyle in
                        Text("\(buttonStyle.description)").tag(buttonStyle.rawValue)
                    }
                }
            }

            Section("Size") {
                Picker("Size", selection: $size) {
                    ForEach(Array(FluentUI.ButtonSizeCategory.allCases.enumerated()), id: \.element) { _, buttonSize in
                        Text("\(buttonSize.description)").tag(buttonSize.rawValue)
                    }
                }
            }
        }
    }
}
