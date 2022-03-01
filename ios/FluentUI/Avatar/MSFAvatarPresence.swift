//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public enum MSFAvatarPresence: Int, CaseIterable {
    case none
    case available
    case away
    case blocked
    case busy
    case doNotDisturb
    case offline
    case unknown

    func color(isOutOfOffice: Bool) -> Color {
        var color = UIColor.clear

        switch self {
        case .none:
            break
        case .available:
            color = UIColor(named: "FluentColors/presenceAvailable", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        case .away:
            color = UIColor(named: "FluentColors/presenceAway", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        case .busy:
            color = UIColor(named: "FluentColors/presenceBusy", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        case .blocked:
            color = UIColor(named: "FluentColors/presenceBlocked", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        case .doNotDisturb:
            color = UIColor(named: "FluentColors/presenceDnd", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        case .offline:
            color = UIColor(named: "FluentColors/presenceOffline", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        case .unknown:
            color = UIColor(named: "FluentColors/presenceUnknown", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
        }

        return Color(color)
    }

    func image(isOutOfOffice: Bool) -> Image {
        var imageName = ""

        switch self {
        case .none:
            break
        case .available:
            imageName = isOutOfOffice ? "ic_fluent_presence_available_16_regular" : "ic_fluent_presence_available_16_filled"
        case .away:
            imageName = isOutOfOffice ? "ic_fluent_presence_oof_16_regular" : "ic_fluent_presence_away_16_filled"
        case .busy:
            imageName = isOutOfOffice ? "ic_fluent_presence_unknown_16_regular" : "ic_fluent_presence_busy_16_filled"
        case .blocked:
            imageName = "ic_fluent_presence_blocked_16_regular"
        case .doNotDisturb:
            imageName = isOutOfOffice ? "ic_fluent_presence_dnd_16_regular" : "ic_fluent_presence_dnd_16_filled"
        case .offline:
            imageName = isOutOfOffice ? "ic_fluent_presence_oof_16_regular" : "ic_fluent_presence_offline_16_regular"
        case .unknown:
            imageName = "ic_fluent_presence_unknown_16_regular"
        }

        return Image(imageName,
                     bundle: FluentUIFramework.resourceBundle)
    }

    public func string() -> String? {
        switch self {
        case .none:
            return nil
        case .available:
            return "Presence.Available".localized
        case .away:
            return "Presence.Away".localized
        case .busy:
            return "Presence.Busy".localized
        case .blocked:
            return "Presence.Blocked".localized
        case .doNotDisturb:
            return "Presence.DND".localized
        case .offline:
            return "Presence.Offline".localized
        case .unknown:
            return "Presence.Unknown".localized
        }
    }
}
