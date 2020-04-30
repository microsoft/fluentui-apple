//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class MSShimmerViewAppearence: NSObject {
    @objc public let tintColor: UIColor
    @objc public let cornerRadius: CGFloat
    @objc public let labelCornerRadius: CGFloat
    @objc public let usesTextHeightForLabels: Bool
    @objc public let labelHeight: CGFloat

    /// Create an apperance shimmer view apperance object
    /// - Parameter tintColor: Tint color of the view.
    /// - Parameter cornerRadius: Corner radius on each view.
    /// - Parameter labelCornerRadius: Corner radius on each UILabel. Set to < 0 to disable and use default `cornerRadius`.
    /// - Parameter usesTextHeightForLabels: True to enable shimmers to auto-adjust to font height for a UILabel -- this will more accurately reflect the text in the label rect rather than using the bounding box. `labelHeight` will take precendence over this property.
    /// - Parameter labelHeight: If greater than 0, a fixed height to use for all UILabels. This will take precedence over `usesTextHeightForLabels`. Set to less than 0 to disable.
    @objc public init(tintColor: UIColor = Colors.Shimmer.tint,
                      cornerRadius: CGFloat = 4.0,
                      labelCornerRadius: CGFloat = 2.0,
                      usesTextHeightForLabels: Bool = false,
                      labelHeight: CGFloat = 11) {
        self.tintColor = tintColor
        self.cornerRadius = cornerRadius
        self.labelCornerRadius = labelCornerRadius
        self.usesTextHeightForLabels = usesTextHeightForLabels
        self.labelHeight = labelHeight
    }
}
