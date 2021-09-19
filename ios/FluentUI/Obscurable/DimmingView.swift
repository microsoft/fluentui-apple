//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DimmingViewType

@objc(MSFDimmingViewType)
public enum DimmingViewType: Int {
    case white = 1
    case black
    case none
}

// MARK: - DimmingView

@objc(MSFDimmingView)
open class DimmingView: UIView {
    public struct Constants {
        public static let blackAlpha: CGFloat = 0.4
        public static let whiteAlpha: CGFloat = 0.5
    }

    private var type: DimmingViewType

    @objc public init(type: DimmingViewType) {
        self.type = type
        super.init(frame: .zero)
        setBackground(type: type)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setBackground(type: DimmingViewType) {
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

// MARK: - DimmingView: Obscurable

extension DimmingView: Obscurable {
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
