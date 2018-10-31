//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSActivityIndicatorCell

open class MSActivityIndicatorCell: UITableViewCell {
    public static let identifier: String = "MSActivityIndicatorCell"
    public static let defaultHeight: CGFloat = 45

    private let activityIndicatorView: MSActivityIndicatorView = {
        let activityIndicatorView = MSActivityIndicatorView(size: .regular)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(activityIndicatorView)
    }

    @objc public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.sizeToFit()
        activityIndicatorView.center = CGPoint(x: UIScreen.main.roundToDevicePixels(contentView.width / 2), y: UIScreen.main.roundToDevicePixels(contentView.height / 2))
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.startAnimating()
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }
}
