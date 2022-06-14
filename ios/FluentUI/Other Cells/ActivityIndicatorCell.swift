//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ActivityIndicatorCell

@objc(MSFActivityIndicatorCell)
open class ActivityIndicatorCell: UITableViewCell, TokenizedControlInternal {
    public static let identifier: String = "ActivityIndicatorCell"

    // MARK: - ActivityIndicatorCell TokenizedControl
    @objc public var activityIndicatorCellOverrideTokens: TableViewCellTokens? {
        didSet {
            self.overrideTokens = activityIndicatorCellOverrideTokens
        }
    }

    let defaultTokens: TableViewCellTokens = .init()
    var tokens: TableViewCellTokens = .init()
    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TableViewCellTokens? {
        didSet {
            updateTokens()
        }
    }

    public func overrideTokens(_ tokens: TableViewCellTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        updateTokens()
    }

    private func updateTokens() {
        tokens = resolvedTokens
        backgroundColor = UIColor(dynamicColor: tokens.cellBackgroundColor)
    }

    private let activityIndicator: MSFActivityIndicator = {
        let activityIndicator = MSFActivityIndicator(size: .small)
        activityIndicator.state.isAnimating = true
        return activityIndicator
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(activityIndicator)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        backgroundColor = UIColor(dynamicColor: tokens.cellBackgroundColor)
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let activityIndicatorView = activityIndicator
        activityIndicatorView.sizeToFit()
        activityIndicatorView.center = CGPoint(x: UIScreen.main.roundToDevicePixels(contentView.frame.width / 2), y: UIScreen.main.roundToDevicePixels(contentView.frame.height / 2))
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTokens()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        updateTokens()
        activityIndicator.state.isAnimating = true
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity
        return CGSize(width: maxWidth, height: tokens.minHeight)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }
}
