//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "HUDTest_SwiftUI.h"

@implementation HUDTestSwiftUI

- (void) setUp{
    hudTestSwiftUI = [[BaseTest alloc] init:@"HUD"];
    [hudTestSwiftUI setUp];
    [hudTestSwiftUI->app.staticTexts[@"SwiftUI Demo"] tap];
}

@end
