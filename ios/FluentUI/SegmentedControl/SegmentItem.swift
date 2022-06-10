//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import Foundation
import UIKit

/// Used for SegmentedControl array of views
@objc(MSFSegmentItem)
public class SegmentItem: NSObject {
    public let title: String
    public let image: UIImage?

    /// This value will determine whether or not to show dot next to the pill button label
    public var isUnread: Bool {
       didSet {
           if oldValue != isUnread {
               NotificationCenter.default.post(name: SegmentItem.isUnreadValueDidChangeNotification, object: self)
           }
       }
   }

    /// Creates a new instance of a `SegmentItem` that holds data used to create a segment in the `SegmentedControl`.
    /// - Parameters
    ///   - title: Title that will be displayed by the segment and used as the accessibility label and large content viewer title.
    ///   - isUnread:  Whether the segment shows the mark that represents the "unread" state.
    @objc public convenience init(title: String, isUnread: Bool = false) {
        self.init(title: title,
                  image: nil,
                  isUnread: isUnread)
    }

    /// Creates a new instance of a `SegmentItem` that holds data used to create a segment in the `SegmentedControl`.
    /// - Parameters
    ///   - title: Title that will be displayed by the segment if the image is nil, and used as the accessibility label and large content viewer title.
    ///   - image: Image that will display instead of the title if not nil.
    ///   - isUnread:  Whether the segment shows the mark that represents the "unread" state.
    @objc public init(title: String,
                      image: UIImage? = nil,
                      isUnread: Bool = false) {
        self.title = title
        self.image = image
        self.isUnread = isUnread
        super.init()
    }

    /// Notification sent when item's `isUnread` value changes.
    static let isUnreadValueDidChangeNotification = NSNotification.Name(rawValue: "SegmentItemisUnreadValueDidChangeNotification")
}
