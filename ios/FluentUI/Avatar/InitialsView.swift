//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFColorSet)
open class ColorSet: NSObject {
    public let background: UIColor
    public let foreground: UIColor

    public init(background: UIColor, foreground: UIColor) {
        self.background = background
        self.foreground = foreground
    }
}

public extension Colors {
    @objc static var avatarColors: [ColorSet] = [
        ColorSet(background: UIColor(light: Palette.darkRedTint40.color, dark: Palette.darkRedShade30.color),
                 foreground: UIColor(light: Palette.darkRedShade30.color, dark: Palette.darkRedTint40.color)),
        ColorSet(background: UIColor(light: Palette.cranberryTint40.color, dark: Palette.cranberryShade30.color),
                 foreground: UIColor(light: Palette.cranberryShade30.color, dark: Palette.cranberryTint40.color)),
        ColorSet(background: UIColor(light: Palette.redTint40.color, dark: Palette.redShade30.color),
                 foreground: UIColor(light: Palette.redShade30.color, dark: Palette.redTint40.color)),
        ColorSet(background: UIColor(light: Palette.pumpkinTint40.color, dark: Palette.pumpkinShade30.color),
                 foreground: UIColor(light: Palette.pumpkinShade30.color, dark: Palette.pumpkinTint40.color)),
        ColorSet(background: UIColor(light: Palette.peachTint40.color, dark: Palette.peachShade30.color),
                 foreground: UIColor(light: Palette.peachShade30.color, dark: Palette.peachTint40.color)),
        ColorSet(background: UIColor(light: Palette.marigoldTint40.color, dark: Palette.marigoldShade30.color),
                 foreground: UIColor(light: Palette.marigoldShade30.color, dark: Palette.marigoldTint40.color)),
        ColorSet(background: UIColor(light: Palette.goldTint40.color, dark: Palette.goldShade30.color),
                 foreground: UIColor(light: Palette.goldShade30.color, dark: Palette.goldTint40.color)),
        ColorSet(background: UIColor(light: Palette.brassTint40.color, dark: Palette.brassShade30.color),
                 foreground: UIColor(light: Palette.brassShade30.color, dark: Palette.brassTint40.color)),
        ColorSet(background: UIColor(light: Palette.brownTint40.color, dark: Palette.brownShade30.color),
                 foreground: UIColor(light: Palette.brownShade30.color, dark: Palette.brownTint40.color)),
        ColorSet(background: UIColor(light: Palette.forestTint40.color, dark: Palette.forestShade30.color),
                 foreground: UIColor(light: Palette.forestShade30.color, dark: Palette.forestTint40.color)),
        ColorSet(background: UIColor(light: Palette.seafoamTint40.color, dark: Palette.seafoamShade30.color),
                 foreground: UIColor(light: Palette.seafoamShade30.color, dark: Palette.seafoamTint40.color)),
        ColorSet(background: UIColor(light: Palette.darkGreenTint40.color, dark: Palette.darkGreenShade30.color),
                 foreground: UIColor(light: Palette.darkGreenShade30.color, dark: Palette.darkGreenTint40.color)),
        ColorSet(background: UIColor(light: Palette.lightTealTint40.color, dark: Palette.lightTealShade30.color),
                 foreground: UIColor(light: Palette.lightTealShade30.color, dark: Palette.lightTealTint40.color)),
        ColorSet(background: UIColor(light: Palette.tealTint40.color, dark: Palette.tealShade30.color),
                 foreground: UIColor(light: Palette.tealShade30.color, dark: Palette.tealTint40.color)),
        ColorSet(background: UIColor(light: Palette.steelTint40.color, dark: Palette.steelShade30.color),
                 foreground: UIColor(light: Palette.steelShade30.color, dark: Palette.steelTint40.color)),
        ColorSet(background: UIColor(light: Palette.blueTint40.color, dark: Palette.blueShade30.color),
                 foreground: UIColor(light: Palette.blueShade30.color, dark: Palette.blueTint40.color)),
        ColorSet(background: UIColor(light: Palette.royalBlueTint40.color, dark: Palette.royalBlueShade30.color),
                 foreground: UIColor(light: Palette.royalBlueShade30.color, dark: Palette.royalBlueTint40.color)),
        ColorSet(background: UIColor(light: Palette.cornFlowerTint40.color, dark: Palette.cornFlowerShade30.color),
                 foreground: UIColor(light: Palette.cornFlowerShade30.color, dark: Palette.cornFlowerTint40.color)),
        ColorSet(background: UIColor(light: Palette.navyTint40.color, dark: Palette.navyShade30.color),
                 foreground: UIColor(light: Palette.navyShade30.color, dark: Palette.navyTint40.color)),
        ColorSet(background: UIColor(light: Palette.lavenderTint40.color, dark: Palette.lavenderShade30.color),
                 foreground: UIColor(light: Palette.lavenderShade30.color, dark: Palette.lavenderTint40.color)),
        ColorSet(background: UIColor(light: Palette.purpleTint40.color, dark: Palette.purpleShade30.color),
                 foreground: UIColor(light: Palette.purpleShade30.color, dark: Palette.purpleTint40.color)),
        ColorSet(background: UIColor(light: Palette.grapeTint40.color, dark: Palette.grapeShade30.color),
                 foreground: UIColor(light: Palette.grapeShade30.color, dark: Palette.grapeTint40.color)),
        ColorSet(background: UIColor(light: Palette.lilacTint40.color, dark: Palette.lilacShade30.color),
                 foreground: UIColor(light: Palette.lilacShade30.color, dark: Palette.lilacTint40.color)),
        ColorSet(background: UIColor(light: Palette.pinkTint40.color, dark: Palette.pinkShade30.color),
                 foreground: UIColor(light: Palette.pinkShade30.color, dark: Palette.pinkTint40.color)),
        ColorSet(background: UIColor(light: Palette.magentaTint40.color, dark: Palette.magentaShade30.color),
                 foreground: UIColor(light: Palette.magentaShade30.color, dark: Palette.magentaTint40.color)),
        ColorSet(background: UIColor(light: Palette.plumTint40.color, dark: Palette.plumShade30.color),
                 foreground: UIColor(light: Palette.plumShade30.color, dark: Palette.plumTint40.color)),
        ColorSet(background: UIColor(light: Palette.beigeTint40.color, dark: Palette.beigeShade30.color),
                 foreground: UIColor(light: Palette.beigeShade30.color, dark: Palette.beigeTint40.color)),
        ColorSet(background: UIColor(light: Palette.minkTint40.color, dark: Palette.minkShade30.color),
                 foreground: UIColor(light: Palette.minkShade30.color, dark: Palette.minkTint40.color)),
        ColorSet(background: UIColor(light: Palette.platinumTint40.color, dark: Palette.platinumShade30.color),
                 foreground: UIColor(light: Palette.platinumShade30.color, dark: Palette.platinumTint40.color)),
        ColorSet(background: UIColor(light: Palette.anchorTint40.color, dark: Palette.anchorShade30.color),
                 foreground: UIColor(light: Palette.anchorShade30.color, dark: Palette.anchorTint40.color))
    ]

}
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

    static func initialsColorSet(fromPrimaryText primaryText: String?, secondaryText: String?) -> ColorSet {
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
        initialsLabel.minimumScaleFactor = 0.5
        initialsLabel.font = avatarSize.font
        initialsLabel.backgroundColor = UIColor.clear
        initialsLabel.textColor = Colors.Avatar.text
        initialsLabel.textAlignment = .center
        initialsLabel.isAccessibilityElement = false
        initialsLabel.baselineAdjustment = .alignCenters
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
