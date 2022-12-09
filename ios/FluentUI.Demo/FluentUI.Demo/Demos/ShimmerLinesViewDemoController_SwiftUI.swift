//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class ShimmerLinesViewDemoControllerSwiftUI: UIHostingController<ShimmerLinesDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ShimmerLinesDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ShimmerLinesDemoView())
        self.title = "Shimmer View (SwiftUI)"
    }
}

struct ShimmerLinesDemoView: View {

    public var body: some View {
        VStack {
            if shimmerDemoContent == .shimmerLabel {
                VStack {
                    Text("This is a single label being shimmered.")
                        .padding(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .shimmering(style: style,
                            usesTextHeightForLabels: usesTextHeightForLabels,
                            animationId: namespace,
                            isLabel: true)
                .padding()
            } else if shimmerDemoContent == .shimmerMultipleLines {
                ShimmerLinesView(style: style,
                                 lineCount: numberOfLines,
                                 firstLineFillPercent: firstLineFillPercent,
                                 lastLineFillPercent: lastLineFillPercent)
                .padding()
            } else if shimmerDemoContent == .shimmerImage {
                Image("PlaceholderImage")
                    .foregroundColor(Color.gray)
                    .shimmering(style: style,
                                usesTextHeightForLabels: usesTextHeightForLabels,
                                animationId: namespace)
                    .padding()
            } else if shimmerDemoContent == .shimmerIndividual {
                HStack {
                    Image("PlaceholderImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.gray)
                        .shimmering(style: style,
                                    usesTextHeightForLabels: usesTextHeightForLabels,
                                    animationId: namespace)
                    VStack {
                        Text("This is the upper label being shimmered.")
                            .shimmering(style: style,
                                        usesTextHeightForLabels: usesTextHeightForLabels,
                                        animationId: namespace,
                                        isLabel: true)
                        Text("This is the lower label being shimmered.")
                            .shimmering(style: style,
                                        usesTextHeightForLabels: usesTextHeightForLabels,
                                        animationId: namespace,
                                        isLabel: true)
                    }
                }
                .padding()
            } else {
                HStack {
                    Image("PlaceholderImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.gray)
                    VStack(spacing: 10) {
                        Text("This is the upper label being shimmered.")
                        Text("This is the lower label being shimmered.")
                    }
                }
                .shimmering(style: style,
                            usesTextHeightForLabels: usesTextHeightForLabels,
                            animationId: namespace)
                .padding()
            }

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $shimmerDemoContent, label: EmptyView()) {
                            Text("Shimmer a Label").tag(ShimmerDemos.shimmerLabel)
                            Text("Shimmer Multiple Lines").tag(ShimmerDemos.shimmerMultipleLines)
                            Text("Shimmer an Image").tag(ShimmerDemos.shimmerImage)
                            Text("Shimmer Individual Views").tag(ShimmerDemos.shimmerIndividual)
                            Text("Shimmer Stack").tag(ShimmerDemos.shimmerStack)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)

                        FluentUIDemoToggle(titleKey: "Uses Text Height For Labels", isOn: $usesTextHeightForLabels)

                        if shimmerDemoContent == .shimmerMultipleLines {
                            HStack {
                                Text("Number of Lines")
                                Spacer()
                                if numberOfLines > 0 {
                                    FluentButton(style: .secondary,
                                                 size: .medium,
                                                 text: "-") {
                                        numberOfLines -= 1
                                    }
                                                 .fixedSize()
                                }
                                FluentButton(style: .secondary,
                                             size: .medium,
                                             text: "+") {
                                    numberOfLines += 1
                                }
                                             .fixedSize()
                            }

                            VStack {
                                Slider(value: $firstLineFillPercent, in: 0...1)
                                Text("First Line Fill Percent: \(firstLineFillPercent * 100, specifier: "%.2f")%")
                            }

                            VStack {
                                Slider(value: $lastLineFillPercent, in: 0...1)
                                Text("Last Line Fill Percent: \(lastLineFillPercent * 100, specifier: "%.2f")%")
                            }
                        }
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Style")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $style, label: EmptyView()) {
                            Text(".revealing").tag(MSFShimmerStyle.revealing)
                            Text(".concealing").tag(MSFShimmerStyle.concealing)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
    }

    @Namespace var namespace: Namespace.ID
    @State var style: MSFShimmerStyle = .revealing
    @State var usesTextHeightForLabels: Bool = true
    @State var numberOfLines: Int = 3
    @State var firstLineFillPercent: Double = 0.94
    @State var lastLineFillPercent: Double = 0.6

    @State private var shimmerDemoContent: ShimmerDemos = .shimmerLabel

    private enum ShimmerDemos: Int, CaseIterable {
        case shimmerLabel
        case shimmerMultipleLines
        case shimmerImage
        case shimmerIndividual
        case shimmerStack
    }
}
