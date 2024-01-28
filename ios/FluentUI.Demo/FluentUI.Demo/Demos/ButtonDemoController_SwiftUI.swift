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
    @ObservedObject var fluentTheme: FluentTheme = .shared

    var body: some View {
      ScrollView {
          VStack(spacing: 16) {
              ForEach(ButtonStyle.allCases, id: \.self) { style in
                  VStack(spacing: 16) {
                      Text(style.description)
                      ForEach(ButtonSizeCategory.allCases, id: \.self) { size in
                          HStack {
                              Text(size.description)
                              Spacer()
                              Button("Text") {}
                                .buttonStyle(FluentButtonStyle(style: style, size: size))
                          }
                      }
                  }
              }
          }
          .padding()
      }
      .fluentTheme(fluentTheme)
    }
}
