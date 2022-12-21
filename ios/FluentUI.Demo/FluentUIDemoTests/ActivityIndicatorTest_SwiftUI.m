//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ActivityIndicatorTest_SwiftUI.h"

@implementation ActivityIndicatorTestSwiftUI

- (void) setUp{
    activityIndicatorTestSwiftUI = [[BaseTest alloc] init:@"ActivityIndicator"];
    [activityIndicatorTestSwiftUI setUp];
    [activityIndicatorTestSwiftUI->app.staticTexts[@"SwiftUI Demo"] tap];
}

@end
