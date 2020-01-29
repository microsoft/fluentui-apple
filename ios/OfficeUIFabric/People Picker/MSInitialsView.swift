//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSInitialsView

/**
 `MSInitialsView` is used to present the initials of an entity such as a person within an avatar view.
 The initials are generated from a provided primary text (e.g. a name) or secondary text (e.g. an email address) and placed as a label above a colored background.
 */
class MSInitialsView: UIView {
    private static func initialsBackgroundColor(fromPrimaryText primaryText: String?, secondaryText: String?) -> UIColor {
        // Set the color based on the primary text and secondary text
        var combined: String
        if let secondaryText = secondaryText, let primaryText = primaryText, secondaryText.count > 0 {
            combined = primaryText + secondaryText
        } else if let primaryText = primaryText {
            combined = primaryText
        } else {
            combined = ""
        }

        let colors = MSColors.avatarBackgroundColors
        let combinedHashable = combined as NSString
        let hashCode = Int(abs(combinedHashable.javaHashCode()))
        return colors[hashCode % colors.count]
    }

    private static func initialsText(fromPrimaryText primaryText: String?, secondaryText: String?) -> String {
        var initials = ""

        if let primaryText = primaryText, primaryText.count > 0 {
            initials = primaryText.initials
        } else if let secondaryText = secondaryText, secondaryText.count > 0 {
            // Use first letter of the secondary text
            initials = String(secondaryText.prefix(1))
        }

        // Fallback to `#` otherwise
        if initials.count == 0 {
            initials = "#"
        }

        return initials.uppercased()
    }

    public var avatarSize: MSAvatarSize {
        didSet {
            frame.size = avatarSize.size
            initialsLabel.font = avatarSize.font
        }
    }

    override var backgroundColor: UIColor? { get { return super.backgroundColor } set { } }

    private var initialsLabel: UILabel!

    /// Initializes the initials view and sizes it with MSAvatarSize
    ///
    /// - Parameter avatarSize: The MSAvatarSize to size the initials view with
    init(avatarSize: MSAvatarSize) {
        self.avatarSize = avatarSize
        super.init(frame: CGRect(origin: .zero, size: avatarSize.size))

        // Initials label
        initialsLabel = UILabel()
        initialsLabel.font = avatarSize.font
        initialsLabel.backgroundColor = UIColor.clear
        initialsLabel.textColor = MSColors.Avatar.text
        initialsLabel.textAlignment = .center
        initialsLabel.isAccessibilityElement = false
        addSubview(initialsLabel)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    /// Sets up in the initialsView by displaying initials from a provided primary text or secondary text
    ///
    /// - Parameters:
    ///   - primaryText: The primary text to use to display the initials from (e.g. a name)
    ///   - secondaryText: The secondary text to use to display the initials if name isn't provided (e.g. an email address)
    public func setup(primaryText: String?, secondaryText: String?) {
        initialsLabel.text = MSInitialsView.initialsText(fromPrimaryText: primaryText, secondaryText: secondaryText)
        setBackgroundColor(MSInitialsView.initialsBackgroundColor(fromPrimaryText: primaryText, secondaryText: secondaryText))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        initialsLabel.frame = bounds
    }

    func setBackgroundColor(_ color: UIColor) {
        super.backgroundColor = color
    }
}
