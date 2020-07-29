//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - Presence

@objc(MSFPresenceSize)
public enum PresenceSize: Int {
    case normal
    case large
    case extraLarge

    public var sizeValue: CGFloat {
        switch self {
        case .normal:
            return 10
        case .large:
            return 12
        case .extraLarge:
            return 16
        }
    }
}

@objc(MSFPresence)
public enum Presence: Int, CaseIterable {
    case none
    case available
    case away
    case busy
    case doNotDisturb
    case outOfOffice
    case offline
    case unknown
    case blocked

    public func image(size: PresenceSize) -> UIImage? {
        var imageName: String?
        var colorName: String?
        let sizeValue = Int(size.sizeValue)

        switch self {
        case .none:
            break
        case .available:
            imageName = "ic_fluent_presence_available_\(sizeValue)_filled"
            colorName = "presence_available"
        case .away:
            imageName = "ic_fluent_presence_away_\(sizeValue)_filled"
            colorName = "presence_away"
        case .busy:
            imageName = "ic_fluent_presence_busy_\(sizeValue)_filled"
            colorName = "presence_busy"
        case .doNotDisturb:
            imageName = "ic_fluent_presence_dnd_\(sizeValue)_filled"
            colorName = "presence_dnd"
        case .outOfOffice:
            imageName = "ic_fluent_presence_oof_\(sizeValue)_regular"
            colorName = "presence_oof"
        case .offline:
            imageName = "ic_fluent_presence_offline_\(sizeValue)_regular"
            colorName = "presence_offline"
        case .unknown:
            imageName = "ic_fluent_presence_unknown_\(sizeValue)_regular"
            colorName = "presence_unknown"
        case .blocked:
            imageName = "ic_fluent_presence_blocked_\(sizeValue)_regular"
            colorName = "presence_blocked"
        }

        var image: UIImage?
        if let imageName = imageName {
            let color = UIColor(named: colorName!, in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
            image = UIImage.staticImageNamed(imageName)!.image(withPrimaryColor: color)
        }

        return image
    }
}
