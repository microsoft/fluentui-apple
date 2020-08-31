//
//  Constants.swift
//  FluentUI.Demo
//
//  Created by Shafeer Puthalan on 31/08/20.
//  Copyright © 2020 Microsoft Corporation. All rights reserved.
//

struct Constants {
    
    struct DemoControllerConstants {
        static let margin: CGFloat = 16
        static let horizontalSpacing: CGFloat = 40
        static let verticalSpacing: CGFloat = 16
        static let rowTextWidth: CGFloat = 75
        static let stackViewSpacing: CGFloat = 10
    }
    
    struct AvatarGroupViewDemoControllerConstants {
        static let settingsTextWidth: CGFloat = 200
        static let avatarsTextWidth: CGFloat = 100
        static let maxTextInputCharCount: Int = 4
    }
    
    struct NavigationControllerDemoControllerConstants {
        static let topAccessoryViewWidthThreshold: CGFloat = 768
    }
    
    struct SideTabBarDemoControllerConstants {
        static let initialBadgeNumbers: [UInt] = [5, 50, 250, 4, 135]
        static let initialHigherBadgeNumbers: [UInt] = [1250, 25505, 3050528, 50890, 2304]
        static let optionsSpacing: CGFloat = 5.0
    }
    
    struct TableViewCellFileAccessoryViewDemoControllerConstants {
        static let stackViewSpacing: CGFloat = 20
        static let cellWidths: [CGFloat] = [320, 375, 414, 423, 424, 503, 504, 583, 584, 615, 616, 751, 752, 899, 900, 924, 950, 1000, 1091, 1092, 1270]
        static let cellPaddingThreshold: CGFloat = 768
        static let largeCellPadding: CGFloat = 16
        static let smallCellPadding: CGFloat = 8
    }
    
    struct ContactCollectionViewDemoControllerConstants {
        static let spacing: CGFloat = 20
        static let leadingSpacing: CGFloat = 30
    }
}
