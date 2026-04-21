//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A text view that automatically detects truncation and supports expand/collapse functionality.
///
/// This component measures the rendered text height and determines if truncation is occurring
/// based on the specified line limit. It provides an optional callback when expandability changes,
/// allowing parent components to react (e.g., show/hide an expand button).
///
public struct ExpandableText: View {
    // MARK: - Public Initializers

    /// Creates an expandable text view with plain text.
    /// - Parameters:
    ///   - text: The text to display.
    ///   - lineLimit: Maximum number of lines to show when collapsed. Default is 2.
    ///   - isExpanded: Optional binding to control expansion state externally.
    ///   - font: The font to use for measurement and display. If nil, uses system body font.
    ///   - onExpandabilityChange: Callback invoked when the expandability status changes.
    public init(
        _ text: String,
        lineLimit: Int = 0,
        isExpanded: Binding<Bool>? = nil,
        font: UIFont? = nil,
        onExpandabilityChange: ((Bool) -> Void)? = nil
    ) {
        self.text = text
        self.attributedText = nil
        self.lineLimit = lineLimit
        self.externalIsExpanded = isExpanded
        self.font = font
        self.onExpandabilityChange = onExpandabilityChange
    }

    /// Creates an expandable text view with attributed text.
    /// - Parameters:
    ///   - attributedText: The attributed text to display.
    ///   - lineLimit: Maximum number of lines to show when collapsed. Default is 2.
    ///   - isExpanded: Optional binding to control expansion state externally.
    ///   - onExpandabilityChange: Callback invoked when the expandability status changes.
    public init(
        _ attributedText: NSAttributedString,
        lineLimit: Int = 0,
        isExpanded: Binding<Bool>? = nil,
        onExpandabilityChange: ((Bool) -> Void)? = nil
    ) {
        self.text = attributedText.string
        self.attributedText = attributedText
        self.lineLimit = lineLimit
        self.externalIsExpanded = isExpanded
		self.font = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
        self.onExpandabilityChange = onExpandabilityChange
    }

    // MARK: - Public Properties

    public var body: some View {
        Group {
            if let attributed = attributedText {
                Text(AttributedString(attributed))
            } else {
                Text(text)
                    .font(font.map { Font($0) } ?? .body)
            }
        }
        .lineLimit(isExpanded ? nil : (lineLimit > 0 ? lineLimit : nil))
        .fixedSize(horizontal: false, vertical: true)
        .onGeometryChange(for: CGFloat.self) { geo in
            geo.size.width
        } action: { width in
            calculateTruncation(availableWidth: width)
        }
    }

    // MARK: - Private Properties

    private let text: String
    private let attributedText: NSAttributedString?
    private let lineLimit: Int
    private let font: UIFont?
    private let onExpandabilityChange: ((Bool) -> Void)?

    @State private var isExpandable: Bool = false
    @State private var internalIsExpanded: Bool = false
    @State private var availableWidth: CGFloat = 0

    private var externalIsExpanded: Binding<Bool>?

    /// The current expansion state, reading from external binding if provided, otherwise using internal state.
    private var isExpanded: Bool {
        get { externalIsExpanded?.wrappedValue ?? internalIsExpanded }
        nonmutating set {
            if let binding = externalIsExpanded {
                binding.wrappedValue = newValue
            } else {
                internalIsExpanded = newValue
            }
        }
    }

    /// The font to use for rendering and measurements, with fallback to body style.
    private var effectiveFont: UIFont {
        font ?? UIFont.preferredFont(forTextStyle: .body)
    }

    /// The height of a single line of text using the effective font.
    private var singleLineHeight: CGFloat {
        ceil(effectiveFont.lineHeight + max(0, effectiveFont.leading))
    }

    // MARK: - Private Methods

    /// Calculates whether the text would be truncated by comparing the full text height to the maximum allowed height.
    /// - Parameter availableWidth: The available width for rendering the text.
    private func calculateTruncation(availableWidth: CGFloat) {
        guard availableWidth > 0 else { return }

        let messageText: String
        if let attributedText {
            messageText = attributedText.string
        } else {
            messageText = text
        }
        // Calculate the full height the text would take without line limit
        let fullHeight = messageText.preferredSize(
            for: effectiveFont,
            width: availableWidth,
            numberOfLines: 0
        ).height
        let maxHeight = singleLineHeight * CGFloat(lineLimit < 1 ? Int.max : lineLimit)

        let newExpandable = fullHeight > maxHeight
        isExpandable = newExpandable
        onExpandabilityChange?(newExpandable)
    }
}
