//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Custom shape to represent shimmer lines as a single view.
/// `lineCount`: Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
/// `firstLineFillPercent`: The percent the first line (if 2+ lines) should fill the available horizontal space.
/// `lastLineFillPercent`: The percent the last line should fill the available horizontal space.
/// `lineHeight`: Height of each line.
/// `lineSpacing`: Spacing between each line.
/// `frame`: Frame of container lines are being presented in.

struct ShimmerLinesShape: Shape {
    func path(in rect: CGRect) -> Path {
        let customShape = Path { p in
            let newLineCount = lineCount == 0 ? Int(floor(frame.height / (lineHeight + lineSpacing))) : lineCount

            for i in 0..<newLineCount {
                let fillPercent: CGFloat = {
                    if i == 0 && newLineCount > 2 {
                        guard let firstLineFillPercent = firstLineFillPercent else {
                            return 1
                        }

                        return firstLineFillPercent
                    } else if i == newLineCount - 1 {
                        guard let lastLineFillPercent = lastLineFillPercent else {
                            return 1
                        }

                        return lastLineFillPercent
                    } else {
                        return 1
                    }
                }()

                p.addPath(Rectangle().path(in: CGRect(x: 0,
                                                      y: ((CGFloat(i) * lineHeight) + (CGFloat(i) * lineSpacing)),
                                                      width: frame.width * fillPercent,
                                                      height: lineHeight)))
            }
        }

        return customShape
    }

    var lineCount: Int
    var firstLineFillPercent: CGFloat?
    var lastLineFillPercent: CGFloat?
    var lineHeight: CGFloat
    var lineSpacing: CGFloat
    var frame: CGSize
}
