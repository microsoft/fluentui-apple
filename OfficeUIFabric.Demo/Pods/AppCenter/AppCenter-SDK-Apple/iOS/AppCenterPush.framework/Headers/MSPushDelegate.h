#import <Foundation/Foundation.h>

@class MSPush;
@class MSPushNotification;

@protocol MSPushDelegate <NSObject>

@optional

/**
 * Callback method that will be called whenever a push notification is clicked
 * from notification center or a notification is received in foreground.
 *
 * @param push The instance of MSPush.
 * @param pushNotification The push notification details.
 */
- (void)push:(MSPush *)push
    didReceivePushNotification:(MSPushNotification *)pushNotification;

@end
