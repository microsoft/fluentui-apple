//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// A lightweight FPS overlay that tracks multiple named counters independently.
/// Call `tick(_:)` from hot paths, and the overlay displays a rolling FPS for each.
class FPSOverlayView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    /// Call this from any hot path to register a frame tick for the given label.
    func tick(_ label: String) {
        let now = CACurrentMediaTime()
        var entry = counters[label] ?? CounterEntry()
        entry.timestamps.append(now)
        // Keep a 1-second rolling window.
        entry.timestamps.removeAll { now - $0 > 1.0 }
        counters[label] = entry
    }

    /// Resets all counters.
    func reset() {
        counters.removeAll()
        textLabel.text = ""
    }

    // MARK: - Private

    private struct CounterEntry {
        var timestamps: [CFTimeInterval] = []

        var fps: Int {
            guard timestamps.count > 1,
                  let first = timestamps.first,
                  let last = timestamps.last,
                  last - first > 0 else {
                return 0
            }
            return Int(Double(timestamps.count - 1) / (last - first))
        }
    }

    private var counters: [String: CounterEntry] = [:]
    private let textLabel = UILabel()
    private var refreshLink: CADisplayLink?

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.75)
        layer.cornerRadius = 8
        clipsToBounds = true
        isUserInteractionEnabled = false

        textLabel.font = .monospacedSystemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])

        let link = CADisplayLink(target: self, selector: #selector(refresh))
        link.preferredFrameRateRange = CAFrameRateRange(minimum: 8, maximum: 15, preferred: 10)
        link.add(to: .main, forMode: .common)
        refreshLink = link
    }

    @objc private func refresh() {
        let now = CACurrentMediaTime()
        // Trim stale entries from all counters.
        for (key, var entry) in counters {
            entry.timestamps.removeAll { now - $0 > 1.0 }
            counters[key] = entry
        }

        let sorted = counters.sorted { $0.key < $1.key }
        let lines = sorted.map { "\($0.key): \($0.value.fps) Hz" }
        textLabel.text = lines.isEmpty ? "—" : lines.joined(separator: "\n")
    }

    deinit {
        refreshLink?.invalidate()
    }
}
