//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class ButtonDemoControllerSwiftUI: UIHostingController<ButtonDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ButtonDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ButtonDemoView())
        self.title = "Button Fluent 2 (SwiftUI)"
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct ButtonDemoView: View {
    @State private var style: FluentUI.ButtonStyle = .accent
    @State private var state: ButtonState = .default
    @State private var size: ButtonSizeCategory = .medium
    @State private var buttonContent: ButtonContent = .both

    @State private var showAlert: Bool = false
    @ObservedObject var fluentTheme: FluentTheme = .shared

    var body: some View {
      ScrollView {
          VStack(spacing: 16) {
              Divider()
              button
                  .frame(minHeight: 200)
              Divider()
              Text("Settings").font(.title2)
              picker(selection: $style)
                  .pickerStyle(.menu)
              picker(selection: $state)
              picker(selection: $size)
              picker(selection: $buttonContent)
          }
          .padding()
          .pickerStyle(.segmented)
      }
      .fluentTheme(fluentTheme)
    }

    var button: some View {
        Button(action: {
            showAlert = true
        }, label: {
            buttonContent.view
        })
            .buttonStyle(FluentButtonStyle(style: style, size: size))
            .environment(\.isEnabled, state != .disabled)
            .alert("Button tapped", isPresented: $showAlert, actions: { EmptyView() })
    }

    @ViewBuilder private func picker<T: Describable & Hashable & CaseIterable>(selection: Binding<T>) -> some View {
        HStack(spacing: 8) {
            Text(T.title)
            Spacer()
            Picker("", selection: selection) {
                ForEach(Array(T.allCases), id: \.self) { state in
                    Text(state.description).tag(state)
                }
            }
            .frame(maxWidth: 200)
        }
    }
}

private protocol Describable {
    static var title: String { get }
    var description: String { get }
}

extension FluentUI.ButtonStyle: Describable {
    static var title: String { "Style" }
}
extension ButtonSizeCategory: Describable {
    static var title: String { "Size" }
}

private enum ButtonState: String, CaseIterable, Describable {
    case `default`
    case disabled

    static var title: String { "State" }
    var description: String { rawValue }
}

private enum ButtonContent: String, CaseIterable, Describable {
    case text
    case image
    case both

    static var title: String { "Content" }
    var description: String { rawValue }

    @ViewBuilder var view: some View {
        switch self {
        case .text:
            Text("Text")
        case .both:
            Label("Text", systemImage: "circle")
        case .image:
            Image(systemName: "circle")
        }
    }
}
