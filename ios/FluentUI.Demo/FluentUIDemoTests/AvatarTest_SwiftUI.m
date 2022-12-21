//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "AvatarTest_SwiftUI.h"

@implementation AvatarTestSwiftUI

- (void) setUp{
    avatarTestSwiftUI = [[BaseTest alloc] init:@"Avatar"];
    [avatarTestSwiftUI setUp];
    [avatarTestSwiftUI->app.staticTexts[@"SwiftUI Demo"] tap];
}

@end
