//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDimmingViewType

@objc public enum MSDimmingViewType: Int {
    case white = 1
    case black
    case none
}

// MARK: - MSDimmingView

open class MSDimmingView: UIView {
    public struct Constants {
        public static let blackAlpha: CGFloat = 0.4
        public static let whiteAlpha: CGFloat = 0.5
    }

    private var type: MSDimmingViewType

    @objc public init(type: MSDimmingViewType) {
        self.type = type
        super.init(frame: .zero)
        setBackground(type: type)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setBackground(type: MSDimmingViewType) {
        switch type {
        case .white:
            backgroundColor = UIColor(white: 1, alpha: Constants.whiteAlpha)
        case .black:
            backgroundColor = UIColor(white: 0, alpha: Constants.blackAlpha)
        case .none:
            backgroundColor = .clear
        }
    }
}

// MARK: - MSDimmingView: Obscurable

extension MSDimmingView: Obscurable {
    var view: UIView { return self }
    var isObscuring: Bool {
        get {
            return backgroundColor != .clear
        }
        set {
            setBackground(type: newValue ? type : .none)
        }
    }
}
