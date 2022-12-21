//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "IndeterminateProgressBarTest_SwiftUI.h"

@implementation IndeterminateProgressBarTestSwiftUI

- (void) setUp{
    indeterminateProgressBarTestSwiftUI = [[BaseTest alloc] init:@"IndeterminateProgressBar"];
    [indeterminateProgressBarTestSwiftUI setUp];
    [indeterminateProgressBarTestSwiftUI->app.staticTexts[@"SwiftUI Demo"] tap];
}

@end
