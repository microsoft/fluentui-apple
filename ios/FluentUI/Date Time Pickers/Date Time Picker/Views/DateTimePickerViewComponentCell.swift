//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - DateTimePickerViewComponentCell

/// TableViewCell representing the cell of component view (should be used only by DateTimePickerViewComponent and not instantiated on its own)
class DateTimePickerViewComponentCell: UITableViewCell, TokenizedControlInternal {
    private struct Constants {
        static let baseHeight: CGFloat = 45
        static let verticalPadding: CGFloat = 12
    }

    static let identifier: String = "DateTimePickerViewComponentCell"

    class var idealHeight: CGFloat {
        let font = UIFont.fluent(FluentTheme.shared.aliasTokens.typography[.body1])
        return max(Constants.verticalPadding * 2 + font.lineHeight, Constants.baseHeight)
    }

    var emphasized: Bool = false {
        didSet {
            updateTextLabelColor()
        }
    }

    typealias TokenSetKeyType = EmptyTokenSet.Tokens
    var tokenSet: EmptyTokenSet = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        updateTextLabelColor()

        textLabel?.textAlignment = .center
        textLabel?.showsLargeContentViewer = true
        textLabel?.font = UIFont.fluent(fluentTheme.aliasTokens.typography[.body1])

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateTextLabelColor()
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        emphasized = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Override -> No selection
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Override -> No highlight
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateTextLabelColor()
    }

    private func updateTextLabelColor() {
        textLabel?.textColor = emphasized ? UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForeground1]) : UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground2])
    }
}
