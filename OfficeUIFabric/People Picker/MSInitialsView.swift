//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSInitialsView

/**
    `MSInitialsView` is used to present the initials of an entity such as a person within an avatar view.
    The initials are generated from a provided name or email address and placed as a label above a colored background.
 */

class MSInitialsView: UIView {
    private static func initialsBackgroundColor(fromName name: String?, email: String?) -> UIColor {
        // Set the color based on the person name and email address
        var combined: String
        if let email = email, let name = name, email.count > 0 {
            combined = name + email
        } else if let name = name {
            combined = name
        } else {
            combined = ""
        }

        let colors = MSColors.avatarBackgroundColors
        let combinedHashable = combined as NSString
        let hashCode = Int(abs(combinedHashable.javaHashCode()))
        return colors[hashCode % colors.count]
    }

    private static func initialsText(fromName name: String?, email: String?) -> String {
        var initials = ""

        if let name = name, name.count > 0 {
            initials = name.initials
        } else if let email = email, email.count > 0 {
            // Use first letter of the email address
            initials = (email as NSString?)?.substring(to: 1) ?? ""
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

    /// Sets up in the initialsView by displaying initials from a provided name or email
    ///
    /// - Parameters:
    ///   - name: The name to use to display the initials from
    ///   - email: The email to use to display the initials if name isn't provided
    public func setup(withName name: String?, email: String?) {
        initialsLabel.text = MSInitialsView.initialsText(fromName: name, email: email)
        // Need to set the background color on super, see next comment
        super.backgroundColor = MSInitialsView.initialsBackgroundColor(fromName: name, email: email)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        initialsLabel.frame = bounds
    }

    func setBackgroundColor(backgroundColor: UIColor) {
        // Don't allow Apple to override the backgroundColor when this view is
        // embedded in a UITableViewCell and the cell is highlighted or selected.
    }
}
