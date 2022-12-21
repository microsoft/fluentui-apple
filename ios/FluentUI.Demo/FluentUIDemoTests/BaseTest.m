//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "BaseTest.h"

@implementation BaseTest

NSString *fluentUIDev = @"FluentUI DEV";

- (instancetype)init:(NSString *)controlNameIn {
    self = [super init];
    app = [[XCUIApplication alloc] init];
    controlName = [NSMutableString stringWithString:controlNameIn];
    return self;
}

- (void)setUp {
    self.continueAfterFailure = NO;
    [app launch];
    
    bool onHomePage = app.staticTexts[fluentUIDev].exists;
    XCUIElement *controlPage = app.staticTexts[controlName];
    bool onDifferentControlPage = !onHomePage && !controlPage.exists;
    XCUIElement *backButton = app.buttons[fluentUIDev].exists ? app.buttons[fluentUIDev] : app.buttons[@"Dismiss"];
    
    if (onHomePage) {
        [controlPage tap];
    } else if (onDifferentControlPage) {
        [backButton tap];
        [controlPage tap];
    }
}

@end
