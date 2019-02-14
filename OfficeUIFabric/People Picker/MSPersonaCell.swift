//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSPersonaCell

open class MSPersonaCell: UITableViewCell {
    private struct Constants {
        static let avatarMarginLeft: CGFloat = 16
        static let avatarMarginRight: CGFloat = 12
        static let avatarSize: MSAvatarSize = .xLarge
        static let interLabelMargin: CGFloat = 2
        static let nameMarginRight: CGFloat = 16
    }

    public static let defaultHeight: CGFloat = 60
    public static let identifier: String = "MSPersonaCell"
    public static var separatorLeftInset: CGFloat {
        return Constants.avatarMarginLeft + Constants.avatarSize.size.width + Constants.avatarMarginRight
    }

    private let avatarView = MSAvatarView(avatarSize: Constants.avatarSize)
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = MSFonts.body
        label.textColor = MSColors.Persona.name
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = MSFonts.footnote
        label.textColor = MSColors.Persona.subtitle
        label.isHidden = true
        return label
    }()

    @objc public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)
        setupCellBackgroundColors()
        nameLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.lineBreakMode = .byTruncatingTail
        avatarView.accessibilityElementsHidden = true
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets up the cell with an MSPersona
    ///
    /// - Parameter persona: The MSPersona to set up the cell with
    open func setup(persona: MSPersona) {
        avatarView.setup(primaryText: persona.name, secondaryText: persona.email, image: persona.avatarImage)
        // Attempt to use email if name is empty
        nameLabel.text = !persona.name.isEmpty ? persona.name : persona.email
        if persona.subtitle != "" {
            subtitleLabel.text = persona.subtitle
            subtitleLabel.isHidden = false
        }
        setNeedsLayout()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        avatarView.left = Constants.avatarMarginLeft
        avatarView.top = (contentView.height - avatarView.height) / 2

        let nameHeight = ceil(nameLabel.font.lineHeight)
        let subtitleHeight = ceil(subtitleLabel.font.lineHeight)

        var textAreaHeight = nameHeight
        if !subtitleLabel.isHidden {
            textAreaHeight += subtitleHeight + Constants.interLabelMargin
        }
        let nameYOffset = UIScreen.main.roundToDevicePixels((contentView.height - textAreaHeight) / 2)
        let nameXOffset = avatarView.right + Constants.avatarMarginRight
        nameLabel.frame = CGRect(
            x: nameXOffset,
            y: nameYOffset,
            width: contentView.width - (nameXOffset + Constants.nameMarginRight),
            height: nameHeight
        )

        if !subtitleLabel.isHidden {
            subtitleLabel.frame = CGRect(
                x: nameLabel.left,
                y: nameLabel.bottom + Constants.interLabelMargin,
                width: nameLabel.width,
                height: subtitleHeight
            )
        }
    }

    // setHighlighted and setSelected maintain the correct background color of avatar when the cell is highlighted or selected.
    // Without this avatar's background color will change to the cell's background color.
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let avatarBackgroundColor = avatarView.avatarBackgroundColor
        super.setHighlighted(highlighted, animated: animated)
        avatarView.avatarBackgroundColor = avatarBackgroundColor
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        let avatarBackgroundColor = avatarView.avatarBackgroundColor
        super.setSelected(selected, animated: animated)
        avatarView.avatarBackgroundColor = avatarBackgroundColor
    }

    private func setupCellBackgroundColors() {
        backgroundColor = MSColors.Persona.background

        let selectedStateBackgroundView = UIView()
        selectedStateBackgroundView.backgroundColor = MSColors.Persona.backgroundSelected
        selectedBackgroundView = selectedStateBackgroundView
    }
}
