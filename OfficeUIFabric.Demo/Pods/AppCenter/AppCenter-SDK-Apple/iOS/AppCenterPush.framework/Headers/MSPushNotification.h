#import <Foundation/Foundation.h>

@interface MSPushNotification : NSObject

/**
 * Notification title.
 */
@property(nonatomic, copy, readonly) NSString *title;

/**
 * Notification message.
 */
@property(nonatomic, copy, readonly) NSString *message;

/**
 * Custom data for the notification.
 */
@property(nonatomic, copy, readonly)
    NSDictionary<NSString *, NSString *> *customData;

@end
