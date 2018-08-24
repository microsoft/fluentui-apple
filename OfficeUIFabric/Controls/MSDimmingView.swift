//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public enum MSDimmingViewType: Int {
    case white = 1
    case black
    case none
}

open class MSDimmingView: UIView {
    public struct Constants {
        public static let blackAlpha: CGFloat = 0.4
        public static let whiteAlpha: CGFloat = 0.5
    }

    public init(type: MSDimmingViewType) {
        super.init(frame: .zero)
        switch type {
        case .white:
            backgroundColor = UIColor(white: 1, alpha: Constants.whiteAlpha)
        case .black:
            backgroundColor = UIColor(white: 0, alpha: Constants.blackAlpha)
        case .none:
            backgroundColor = .clear
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
