//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import Foundation

/// Used for SegmentedControl array of views
@objc(MSFSegmentItem)
public class SegmentItem: NSObject {
    public let title: String

    /// This value will determine whether or not to show dot next to the pill button label
    public var isUnread: Bool {
       didSet {
           if oldValue != isUnread {
               NotificationCenter.default.post(name: SegmentItem.isUnreadValueDidChangeNotification, object: self)
           }
       }
   }

    @objc public init(title: String, isUnread: Bool = false) {
        self.title = title
        self.isUnread = isUnread
        super.init()
    }

    /// Notification sent when item's `isUnread` value changes.
    static let isUnreadValueDidChangeNotification = NSNotification.Name(rawValue: "SegmentItemisUnreadValueDidChangeNotification")
}
