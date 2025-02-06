//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class AvatarGroupDemoControllerSwiftUI: DemoHostingController {
    required init(rootView: AnyView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: AnyView(AvatarGroupDemoView()))
        self.title = "AvatarGroup (SwiftUI)"
    }
}

struct AvatarGroupDemoView: View {
    static let defaultSize: MSFAvatarSize = .size72
    static let startingAvatarCount: Int = 5
    static let startingMaxDisplayedAvatars: Int = 3

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    @State var useAlternateBackground: Bool = true

    // Avatar settings
    @State var isRingVisible: Bool = false
    @State var showImage: Bool = true
    @State var showImageBasedRingColor: Bool = false
    @State var hasRingInnerGap: Bool = true

    // AvatarGroup settings
    @State var maxDisplayedAvatars: Int = startingMaxDisplayedAvatars
    @State var overflowCount: Int = 0
    @State var hasBackgroundOutline: Bool = false
    @State var isUnread: Bool = false
    @State var size: MSFAvatarSize = AvatarGroupDemoView.defaultSize
    @State var style: MSFAvatarGroupStyle = .stack
    @State var avatarCount: Int = startingAvatarCount

    @ViewBuilder
    func avatarFromSamplePersona(_ index: Int) -> Avatar {
        let samplePersona = samplePersonas[index % samplePersonas.count]
        Avatar(style: .default,
               size: size,
               image: showImage ? samplePersona.image : nil,
               primaryText: samplePersona.name,
               secondaryText: samplePersona.email)
        .isRingVisible(isRingVisible)
        .hasRingInnerGap(hasRingInnerGap)
        .imageBasedRingColor(showImageBasedRingColor ? AvatarDemoController.colorfulCustomImage : nil)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                fluentTheme.swiftUIColor(useAlternateBackground ? .backgroundCanvas : .background1)
                AvatarGroup(style: style,
                            size: size,
                            avatarCount: avatarCount,
                            maxDisplayedAvatars: maxDisplayedAvatars,
                            overflowCount: overflowCount,
                            hasBackgroundOutline: hasBackgroundOutline,
                            isUnread: isUnread) { index in
                    avatarFromSamplePersona(index)
                }.fixedSize()
            }
            .frame(height: 120, alignment: .center)

            FluentList {
                FluentListSection("Content") {
                    Stepper("Avatar Count: \(avatarCount)", value: $avatarCount, in: (0...Int.max))
                    Stepper("Max Displayed Avatars: \(maxDisplayedAvatars)", value: $maxDisplayedAvatars)
                    Stepper("Overflow Count: \(overflowCount)", value: $overflowCount)
                    Toggle("Has Background Outline", isOn: $hasBackgroundOutline)
                    Toggle("Show Avatar Images", isOn: $showImage)
                    Toggle("Unread Dot", isOn: $isUnread)
                    Toggle("Alternate Background", isOn: $useAlternateBackground)
                }

                FluentListSection("Ring") {
                    Toggle("Ring Visible", isOn: $isRingVisible)
                    Toggle("Image Based Ring Color", isOn: $showImageBasedRingColor)
                    Toggle("Has Ring Inner Gap", isOn: $hasRingInnerGap)
                }

                FluentListSection("Style") {
                    Picker(selection: $style, label: EmptyView()) {
                        Text(".stack").tag(MSFAvatarGroupStyle.stack)
                        Text(".pile").tag(MSFAvatarGroupStyle.pile)
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                FluentListSection("Size") {
                    Picker("Avatar Size", selection: $size) {
                        ForEach(MSFAvatarSize.allCases.reversed(), id: \.self) { avatarSize in
                            Text("\(avatarSize.description)").tag(avatarSize)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .fluentListStyle(.insetGrouped)
        }
        .fluentTheme(fluentTheme)
        .tint(Color(fluentTheme.color(.brandForeground1)))
    }
}

extension MSFAvatarSize {
    var description: String {
        switch self {
        case .size16:
            return ".size16"
        case .size20:
            return ".size20"
        case .size24:
            return ".size24"
        case .size32:
            return ".size32"
        case .size40:
            return ".size40"
        case .size56:
            return ".size56"
        case .size72:
            return ".size72"
        }
    }
}
