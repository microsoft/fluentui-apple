//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BottomSheetView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        // We need to have the shadow on the superview of the view that does the corner masking.
        // Otherwise the view will mask its own shadow.
        layer.shadowColor = Constants.Shadow.color
        layer.shadowOffset = Constants.Shadow.offset
        layer.shadowOpacity = Constants.Shadow.opacity
        layer.shadowRadius = Constants.Shadow.radius

        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private(set) lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = Colors.NavigationBar.background
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.cornerCurve = .continuous
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.clipsToBounds = true
        return contentView
    }()
    
    private struct Constants {
        static let cornerRadius: CGFloat = 14

        struct Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let opacity: Float = 0.14
            static let radius: CGFloat = 8
            static let offset: CGSize = CGSize(width: 0, height: 4)
        }
    }
}
