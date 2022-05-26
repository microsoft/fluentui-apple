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
    public let isTemplateImage: Bool

    /// This value will determine whether or not to show dot next to the pill button label
    public var isUnread: Bool {
       didSet {
           if oldValue != isUnread {
               NotificationCenter.default.post(name: SegmentItem.isUnreadValueDidChangeNotification, object: self)
           }
       }
   }

    @objc public convenience init(title: String, isUnread: Bool = false) {
        self.init(title: title, image: nil, isUnread: isUnread)
    }

    @objc public init(title: String,
                      image: UIImage? = nil,
                      isTemplateImage: Bool = true,
                      isUnread: Bool = false) {
        self.title = title
        self.image = image
        self.isTemplateImage = isTemplateImage
        self.isUnread = isUnread
        super.init()
    }

    /// Notification sent when item's `isUnread` value changes.
    static let isUnreadValueDidChangeNotification = NSNotification.Name(rawValue: "SegmentItemisUnreadValueDidChangeNotification")
}
