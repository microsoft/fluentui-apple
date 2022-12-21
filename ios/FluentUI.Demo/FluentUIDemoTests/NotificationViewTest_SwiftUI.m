//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "NotificationViewTest_SwiftUI.h"

@implementation NotificationViewTestSwiftUI

- (void) setUp{
    notificationViewTestSwiftUI = [[BaseTest alloc] init:@"NotificationView"];
    [notificationViewTestSwiftUI setUp];
    [notificationViewTestSwiftUI->app.buttons[@"Show"].firstMatch tap];
}

@end
