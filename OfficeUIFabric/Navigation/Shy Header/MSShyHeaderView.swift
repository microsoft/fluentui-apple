//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSShyHeaderView

/// "Hideable" header view for use in a navigation stack, appearing above a content view controller
/// Used to contain an accessory provided by the VC contained by the NavigatableShyContainerVC
/// This class in itself is fairly straightforward, defining a height and a containment layout
/// The animation around showing/hiding this view progressively is handled by its superview/superVC, an instance of MSShyHeaderController
class MSShyHeaderView: UIView {
    /// Defines all possible states of the header view's appearance
    ///
    /// - exposed: Fully showing header
    /// - exposing: partially showing header (defined by a progress fraction, 0.0 - 1.0)
    /// - concealed: fully concealed (hidden)
    enum ShyViewExposure: Equatable {
        case concealed
        case exposing(CGFloat)
        case exposed

        /// Returns the progress between concealed and exposed as a fraction of the possible states
        /// Values are represented as a fraction (0.5) not as a percentage (50.0)
        /// Concealed and fully exposed are represented as 0.0 and 1.0, respectively
        var progress: CGFloat {
            switch self {
            case .concealed:
                return 0.0
            case .exposing(let progress):
                return progress
            case .exposed:
                return 1.0
            }
        }

        /// Initializer accepting a progress value
        /// Values outside the range 0.0-1.0 will be adjusted
        ///
        /// - Parameter progress: progress of the exposure, represented as a fraction
        init(withProgress progress: CGFloat) {
            if progress <= 0.0 {
                self = .concealed
            } else if progress >= 1.0 {
                self = .exposed
            } else {
                self = .exposing(progress)
            }
        }
    }

    private struct Constants {
        static let maxHeightNoAccessory: CGFloat = 12
        static let maxHeightWithAccessory: CGFloat = 52
        static let shyContainerContentInsets = UIEdgeInsets(top: 6, left: 16, bottom: 10, right: 16) //content insets of the stack inside the header view
    }

    /// Header's current state
    var exposure: ShyViewExposure = .exposed {
        didSet {
            switch exposure {
            case .concealed:
                guard cancelsContentFirstRespondingOnHide else {
                    return
                }
                accessoryView?.resignFirstResponder()
            default:
                return
            }
        }
    }

    /// The contained accessory view
    /// Setter removes previous value and inserts the new one into the content stack
    /// AccessoryContentViews are responsible for their own internal layouts
    /// They will be contained in a UIStackView that fills the width of the header
    var accessoryView: UIView? {
        willSet {
            accessoryView?.removeFromSuperview()
            contentStackView.removeFromSuperview()
        }
        didSet {
            if let newContentView = accessoryView {
                initContentStackView()
                contentStackView.addArrangedSubview(newContentView)
            }
        }
    }

    var maxHeight: CGFloat { return accessoryView == nil ? Constants.maxHeightNoAccessory : Constants.maxHeightWithAccessory }

    var navigationBarStyle: MSNavigationBar.Style = .primary {
        didSet {
            backgroundColor = navigationBarStyle.backgroundColor
            updateShadowVisibility()
        }
    }

    private let contentStackView = UIStackView()
    private let shadow = MSSeparator(style: .shadow)

    private var needsShadow: Bool {
        var needsShadow = navigationBarStyle == .system
        if #available(iOS 13, *) {
            needsShadow = needsShadow && traitCollection.userInterfaceStyle != .dark
        }
        return needsShadow
    }
    private var showsShadow: Bool = false {
        didSet {
            if showsShadow == oldValue {
                return
            }
            if showsShadow {
                initShadow()
            } else {
                shadow.removeFromSuperview()
            }
        }
    }

    /// Whether the header should cancel its first responder status when it moves to the concealed state
    /// e.g. should cancel a search on scroll
    private var cancelsContentFirstRespondingOnHide: Bool = false

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateShadowVisibility()
    }

    private func initContentStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.shyContainerContentInsets.left),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -1 * Constants.shyContainerContentInsets.right),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.shyContainerContentInsets.top),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * Constants.shyContainerContentInsets.bottom)
        ])
    }

    private func initShadow() {
        shadow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shadow)
        NSLayoutConstraint.activate([
            shadow.leftAnchor.constraint(equalTo: leftAnchor),
            shadow.rightAnchor.constraint(equalTo: rightAnchor),
            shadow.topAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateShadowVisibility() {
        showsShadow = needsShadow
    }
}
