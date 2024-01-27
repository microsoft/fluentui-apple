//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Definition of a DemoController
struct DemoDescriptor: Identifiable {
    let title: String
    let controllerClass: UIViewController.Type
    let supportsVisionOS: Bool
    let id = UUID()

    init(_ title: String, _ controllerClass: UIViewController.Type, supportsVisionOS: Bool) {
        self.title = title
        self.controllerClass = controllerClass
        self.supportsVisionOS = supportsVisionOS
    }
}

struct Demos {
    static let fluent2: [DemoDescriptor] = [
        DemoDescriptor("ActivityIndicator", ActivityIndicatorDemoController.self, supportsVisionOS: false),
        DemoDescriptor("Avatar", AvatarDemoController.self, supportsVisionOS: true),
        DemoDescriptor("AvatarGroup", AvatarGroupDemoController.self, supportsVisionOS: true),
        DemoDescriptor("BadgeField", BadgeFieldDemoController.self, supportsVisionOS: true),
        DemoDescriptor("BadgeView", BadgeViewDemoController.self, supportsVisionOS: false),
        DemoDescriptor("BottomCommandingController", BottomCommandingDemoController.self, supportsVisionOS: true),
        DemoDescriptor("BottomSheetController", BottomSheetDemoController.self, supportsVisionOS: false),
        DemoDescriptor("Button", ButtonDemoController.self, supportsVisionOS: true),
        DemoDescriptor("CardNudge", CardNudgeDemoController.self, supportsVisionOS: false),
        DemoDescriptor("CommandBar", CommandBarDemoController.self, supportsVisionOS: false),
        DemoDescriptor("DrawerController", DrawerDemoController.self, supportsVisionOS: true),
        DemoDescriptor("HUD", HUDDemoController.self, supportsVisionOS: true),
        DemoDescriptor("IndeterminateProgressBar", IndeterminateProgressBarDemoController.self, supportsVisionOS: false),
        DemoDescriptor("Label", LabelDemoController.self, supportsVisionOS: true),
        DemoDescriptor("ListActionItem", ListActionItemDemoController.self, supportsVisionOS: false),
        DemoDescriptor("ListItem", ListItemDemoController.self, supportsVisionOS: false),
        DemoDescriptor("MultilineCommandBar", MultilineCommandBarDemoController.self, supportsVisionOS: false),
        DemoDescriptor("NavigationController", NavigationControllerDemoController.self, supportsVisionOS: true),
        DemoDescriptor("NotificationView", NotificationViewDemoController.self, supportsVisionOS: true),
        DemoDescriptor("Other cells", OtherCellsDemoController.self, supportsVisionOS: false),
        DemoDescriptor("PeoplePicker", PeoplePickerDemoController.self, supportsVisionOS: false),
        DemoDescriptor("PersonaButtonCarousel", PersonaButtonCarouselDemoController.self, supportsVisionOS: false),
        DemoDescriptor("PillButton", PillButtonDemoController.self, supportsVisionOS: true),
        DemoDescriptor("PillButtonBar", PillButtonBarDemoController.self, supportsVisionOS: true),
        DemoDescriptor("PopupMenuController", PopupMenuDemoController.self, supportsVisionOS: false),
        DemoDescriptor("SearchBar", SearchBarDemoController.self, supportsVisionOS: true),
        DemoDescriptor("SegmentedControl", SegmentedControlDemoController.self, supportsVisionOS: false),
        DemoDescriptor("ShimmerView", ShimmerViewDemoController.self, supportsVisionOS: false),
        DemoDescriptor("SideTabBar", SideTabBarDemoController.self, supportsVisionOS: false),
        DemoDescriptor("TabBarView", TabBarViewDemoController.self, supportsVisionOS: true),
        DemoDescriptor("TableViewCell", TableViewCellDemoController.self, supportsVisionOS: true),
        DemoDescriptor("TableViewHeaderFooterView", TableViewHeaderFooterViewDemoController.self, supportsVisionOS: true),
        DemoDescriptor("Text Field", TextFieldDemoController.self, supportsVisionOS: false),
        DemoDescriptor("Tooltip", TooltipDemoController.self, supportsVisionOS: false),
        DemoDescriptor("TwoLineTitleView", TwoLineTitleViewDemoController.self, supportsVisionOS: false)
    ]

    static let fluent2DesignTokens: [DemoDescriptor] = [
        DemoDescriptor("Global Color Tokens", GlobalColorTokensDemoController.self, supportsVisionOS: true),
        DemoDescriptor("Alias Color Tokens", AliasColorTokensDemoController.self, supportsVisionOS: true),
        DemoDescriptor("Shadow Tokens", ShadowTokensDemoController.self, supportsVisionOS: true),
        DemoDescriptor("Typography Tokens", TypographyTokensDemoController.self, supportsVisionOS: true)
    ]

    static let controls: [DemoDescriptor] = [
        DemoDescriptor("Card", CardViewDemoController.self, supportsVisionOS: false),
        DemoDescriptor("DateTimePicker", DateTimePickerDemoController.self, supportsVisionOS: false),
        DemoDescriptor("PersonaListView", PersonaListViewDemoController.self, supportsVisionOS: false),
        DemoDescriptor("TableViewCellShimmer", TableViewCellShimmerDemoController.self, supportsVisionOS: false)
    ]

    static let debug: [DemoDescriptor] = [
        DemoDescriptor("DEBUG: Objective-C Demos", ObjectiveCDemoController.self, supportsVisionOS: false)
    ]
}
