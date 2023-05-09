//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl {
    /// The type of tokens associated with this `TokenizedControl`.
    associatedtype TokenSetKeyType: TokenSetKey
    associatedtype TokenSetType: ControlTokenSet<Self.TokenSetKeyType>

    /// The set of tokens associated with this `TokenizedControl`.
    var tokenSet: TokenSetType { get }
}

/// Internal extension to `TokenizedControl` that adds the ability to modify the active tokens.
protocol TokenizedControlInternal: TokenizedControl {
    /// The current `FluentTheme` applied to this control. Usually acquired via the environment.
    var fluentTheme: FluentTheme { get }
}

protocol TokenizedThemeObserver: TokenizedControlInternal, NSObject {
    func addThemeObserver(for view: UIView) -> NSObjectProtocol
}

extension TokenizedThemeObserver {
    @discardableResult func addThemeObserver(for view: UIView) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: .didChangeTheme,
                                                      object: nil,
                                                      queue: nil) { [weak self, weak view] notification in
            guard let strongSelf = self,
                  let themeView = notification.object as? UIView,
                  let view,
                  view.isDescendant(of: themeView)
            else {
                return
            }
            strongSelf.tokenSet.update(themeView.fluentTheme)
        }
    }
}
