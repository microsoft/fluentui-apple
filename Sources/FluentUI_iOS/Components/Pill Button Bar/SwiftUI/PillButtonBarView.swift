//
//  PillButtonBar.swift
//  FluentUI
//
//  Created by Lamine Male on 2025-08-18.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public struct PillButtonBarView: View {
    @Binding var selectedIndex: Int
    @Binding var shouldCenterAlign: Bool
    private var datas: [PillButtonViewModel]

    @State private var pillFrames: [Int: CGRect] = [:]
    @State private var scrollViewFrame: CGRect = .zero

    public init(datas: [PillButtonViewModel], selectedIndex: Binding<Int>, shouldCenterAlign: Binding<Bool> = .constant(false)) {
        self.datas = datas
        self._selectedIndex = selectedIndex
        self._shouldCenterAlign = shouldCenterAlign
    }

    public var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.pillSpacing) {
                    ForEach(datas.indices, id: \.self) { index in
                        pillButton(for: index, scrollProxy: scrollProxy)
                            .background(GeometryReader { geo in
                                Color.clear
                                    .preference(key: PillFramePreferenceKey.self,
                                                value: [index: geo.frame(in: .global)])
                            })
                            .id(index)
                    }
                }
                .padding(.vertical, Constants.verticalPadding)
                .padding(.horizontal, Constants.horizontalPadding)
            }
            .onAppear {
                DispatchQueue.main.async {
                    scrollToSelectedOnAppear(scrollProxy)
                }
            }
            .background(GeometryReader { geo in
                Color.clear
                    .onAppear {
                        scrollViewFrame = geo.frame(in: .global)
                    }
            })
            .frame(maxWidth: .infinity, alignment: shouldCenterAlign ? .center : .leading)
            .onPreferenceChange(PillFramePreferenceKey.self) { value in
                pillFrames = value
            }
            .onChange(of: selectedIndex) { newIndex in
                guard let pillFrame = pillFrames[newIndex] else { return }

                let scrollMinX = scrollViewFrame.minX
                let scrollMaxX = scrollViewFrame.maxX

                if pillFrame.maxX > scrollMaxX {
                    // Pill is clipped on the trailing edge
                    withAnimation {
                        scrollProxy.scrollTo(newIndex, anchor: UnitPoint(x: Constants.scrollAnchorTrailingX - (Constants.scrollPadding / scrollViewFrame.width), y: Constants.scrollAnchorY))
                    }
                } else if pillFrame.minX < scrollMinX {
                    // Pill is clipped on the leading edge
                    withAnimation {
                        scrollProxy.scrollTo(newIndex, anchor: UnitPoint(x: Constants.scrollPadding / scrollViewFrame.width, y: Constants.scrollAnchorY))
                    }
                }
            }
        }
    }

    private func pillButton(for index: Int, scrollProxy: ScrollViewProxy) -> some View {
        SwiftUI.Button {
            selectedIndex = index
            if datas[index].isUnread {
                datas[index].isUnread = false
            }
        } label: {
            Text(datas[index].title)
        }
        .buttonStyle(PillButtonViewStyle(style: .primary,
                                         isSelected: selectedIndex == index,
                                         isUnread: datas[index].isUnread,
                                         leadingImage: datas[index].leadingImage))
    }

    private func scrollToSelectedOnAppear(_ scrollProxy: ScrollViewProxy) {
        guard scrollViewFrame.width > 0 else { return }

        let scrollWidth = scrollViewFrame.width

        let anchorX = Constants.scrollPadding / scrollWidth
        scrollProxy.scrollTo(selectedIndex, anchor: UnitPoint(x: anchorX, y: Constants.scrollAnchorY))
    }
}

private struct Constants {
    static let pillSpacing: CGFloat = 8.0
    static let verticalPadding: CGFloat = 10.0
    static let horizontalPadding: CGFloat = 10.0
    static let scrollPadding: CGFloat = 40.0
    static let scrollAnchorY: CGFloat = 0.5
    static let scrollAnchorTrailingX: CGFloat = 1.0
}

private struct PillFramePreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// View model object used to create a `PillButtonView`.
public class PillButtonViewModel: ObservableObject {
    /// Determines whether the pill button should show the unread dot.
    @Published public var isUnread: Bool
    /// The leading image icon of the pill button.
    @Published public var leadingImage: Image?
    /// The title of the pill button.
    public let title: String

    /// Initializes a new `PillButtonViewModel`.
    ///
    /// - Parameters:
    ///   - title: The title of the pill button.
    ///   - leadingImage: The leading image icon of the pill button.
    ///   - isUnread: Determines whether the pill button should show the unread dot.
    public init(title: String,
                leadingImage: Image? = nil,
                isUnread: Bool = false) {
        self.title = title
        self.leadingImage = leadingImage
        self.isUnread = isUnread
    }
}
