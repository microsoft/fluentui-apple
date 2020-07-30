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
        var color: UIColor?
        let sizeValue = Int(size.sizeValue)

        switch self {
        case .none:
            break
        case .available:
            imageName = "ic_fluent_presence_available_\(sizeValue)_filled"
            color = Colors.Palette.presenceAvailable.color
        case .away:
            imageName = "ic_fluent_presence_away_\(sizeValue)_filled"
            color = Colors.Palette.presenceAway.color
        case .busy:
            imageName = "ic_fluent_presence_busy_\(sizeValue)_filled"
            color = Colors.Palette.presenceBusy.color
        case .doNotDisturb:
            imageName = "ic_fluent_presence_dnd_\(sizeValue)_filled"
            color = Colors.Palette.presenceDnd.color
        case .outOfOffice:
            imageName = "ic_fluent_presence_oof_\(sizeValue)_regular"
            color = Colors.Palette.presenceOof.color
        case .offline:
            imageName = "ic_fluent_presence_offline_\(sizeValue)_regular"
            color = Colors.Palette.presenceOffline.color
        case .unknown:
            imageName = "ic_fluent_presence_unknown_\(sizeValue)_regular"
            color = Colors.Palette.presenceUnknown.color
        case .blocked:
            imageName = "ic_fluent_presence_blocked_\(sizeValue)_regular"
            color = Colors.Palette.presenceBlocked.color
        }

        var image: UIImage?
        if let imageName = imageName {
            image = UIImage.staticImageNamed(imageName)!.image(withPrimaryColor: color!)
        }

        return image
    }

    public var string: String? {
        switch self {
        case .none:
            return nil
        case .available:
            return "Presence.Available".localized
        case .away:
            return "Presence.Away".localized
        case .busy:
            return "Presence.Busy".localized
        case .doNotDisturb:
            return "Presence.DND".localized
        case .outOfOffice:
            return "Presence.OOF".localized
        case .offline:
            return "Presence.Offline".localized
        case .unknown:
            return "Presence.Unknown".localized
        case .blocked:
            return "Presence.Blocked".localized
        }
    }
}
