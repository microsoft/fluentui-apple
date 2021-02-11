//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: InitialsView

/**
 `InitialsView` is used to present the initials of an entity such as a person within an avatar view.
 The initials are generated from a provided primary text (e.g. a name) or secondary text (e.g. an email address) and placed as a label above a colored background.
 */
class InitialsView: UIView {
    static func initialsHashCode(fromPrimaryText primaryText: String?, secondaryText: String?) -> Int {
        var combined: String
        if let secondaryText = secondaryText, let primaryText = primaryText, secondaryText.count > 0 {
            combined = primaryText + secondaryText
        } else if let primaryText = primaryText {
            combined = primaryText
        } else {
            combined = ""
        }

        let combinedHashable = combined as NSString
        return Int(abs(javaHashCode(combinedHashable)))
    }

    static func initialsCalculatedColor(fromPrimaryText primaryText: String?, secondaryText: String?, colorOptions: [UIColor]? = nil) -> UIColor {
        guard let colors = colorOptions else {
            return .black
        }

        // Set the color based on the primary text and secondary text
        let hashCode = initialsHashCode(fromPrimaryText: primaryText, secondaryText: secondaryText)
        return colors[hashCode % colors.count]
    }

    private static func initialsColorSet(fromPrimaryText primaryText: String?, secondaryText: String?) -> ColorSet {
        let hashCode = initialsHashCode(fromPrimaryText: primaryText, secondaryText: secondaryText)
        let colorSets = Colors.avatarColors
        return colorSets[hashCode % colorSets.count]
    }

    static func initialsText(fromPrimaryText primaryText: String?, secondaryText: String?) -> String {
        var initials = ""

        if let primaryText = primaryText, primaryText.count > 0 {
            initials = initialLetters(primaryText)
        } else if let secondaryText = secondaryText, secondaryText.count > 0 {
            // Use first letter of the secondary text
            initials = String(secondaryText.prefix(1))
        }

        return initials.uppercased()
    }

    private static func initialLetters(_ text: String) -> String {
        var initials = ""

        // Use the leading character from the first two words in the user's name
        let nameComponents = text.components(separatedBy: " ")
        for nameComponent: String in nameComponents {
            let trimmedName = nameComponent.trimmed()
            if trimmedName.count < 1 {
                continue
            }
            let initial = trimmedName.index(trimmedName.startIndex, offsetBy: 0)
            let initialLetter = String(trimmedName[initial])
            let initialUnicodeScalars = initialLetter.unicodeScalars
            let initialUnicodeScalar = initialUnicodeScalars[initialUnicodeScalars.startIndex]
            // Discard name if first char is not a letter
            let isInitialLetter: Bool = initialLetter.count > 0 && CharacterSet.letters.contains(initialUnicodeScalar)
            if isInitialLetter && initials.count < 2 {
                initials += initialLetter
            }
        }

        return initials
    }

    /// To ensure iOS and Android achieve the same result when generating string hash codes (e.g. to determine avatar colors) we've copied Java's String implementation of `hashCode`.
    /// Must use Int32 as JVM specification is 32-bits for ints
    /// - Returns: hash code of string
    private static func javaHashCode(_ text: NSString) -> Int32 {
        var hash: Int32 = 0
        for i in 0..<text.length {
            // Allow overflows, mimicking Java behavior
            hash = 31 &* hash &+ Int32(text.character(at: i))
        }
        return hash
    }

    public var avatarSize: AvatarLegacySize {
        didSet {
            frame.size = avatarSize.size
            initialsLabel.font = avatarSize.font
        }
    }

    override var backgroundColor: UIColor? { get { return super.backgroundColor } set { } }

    private var initialsLabel: UILabel!

    /// Initializes the initials view and sizes it with AvatarSize
    ///
    /// - Parameter avatarSize: The AvatarSize to size the initials view with
    init(avatarSize: AvatarLegacySize) {
        self.avatarSize = avatarSize
        super.init(frame: CGRect(origin: .zero, size: avatarSize.size))

        // Initials label
        initialsLabel = UILabel()
        initialsLabel.adjustsFontSizeToFitWidth = true
        initialsLabel.minimumScaleFactor = 0.8
        initialsLabel.font = avatarSize.font
        initialsLabel.backgroundColor = UIColor.clear
        initialsLabel.textColor = Colors.Avatar.text
        initialsLabel.textAlignment = .center
        initialsLabel.isAccessibilityElement = false
        addSubview(initialsLabel)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private struct Constants {
        /// Adjustment multiplier to accommodate for the inner stroke in `AvatarView` border option.
        /// `adjustsFontSizeToFitWidth` will not adjust unless text is on or exceeds the containing bounds.
        static let borderAdjustment: CGFloat = 2.5
    }

    // MARK: Setup

    /// Sets up in the initialsView by displaying initials from a provided primary text or secondary text
    ///
    /// - Parameters:
    ///   - primaryText: The primary text to use to display the initials from (e.g. a name)
    ///   - secondaryText: The secondary text to use to display the initials if name isn't provided (e.g. an email address)
    public func setup(primaryText: String?, secondaryText: String?) {
        initialsLabel.text = InitialsView.initialsText(fromPrimaryText: primaryText, secondaryText: secondaryText)
        let colorSet = InitialsView.initialsColorSet(fromPrimaryText: primaryText, secondaryText: secondaryText)
        setFontColor(colorSet.foreground)
        setBackgroundColor(colorSet.background)
    }

    /// Sets up the initialsView with the provided initials text.
    /// - Parameter initialsText: the initials text.
    public func setup(initialsText: String?) {
        initialsLabel.text = initialsText
        let colorSet = InitialsView.initialsColorSet(fromPrimaryText: initialsText, secondaryText: nil)
        setFontColor(colorSet.foreground)
        setBackgroundColor(colorSet.background)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width - (avatarSize.insideBorder * Constants.borderAdjustment)
        let height = bounds.height - (avatarSize.insideBorder * Constants.borderAdjustment)
        let x = bounds.origin.x + avatarSize.insideBorder * (Constants.borderAdjustment / 2)
        let y = bounds.origin.y + avatarSize.insideBorder * (Constants.borderAdjustment / 2)
        initialsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
    }

    func setBackgroundColor(_ color: UIColor) {
        super.backgroundColor = color
    }

    func setFontColor(_ color: UIColor) {
        initialsLabel.textColor = color
    }
}
