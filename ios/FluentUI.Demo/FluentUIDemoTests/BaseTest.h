//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <XCTest/XCTest.h>

@interface BaseTest : XCTestCase {
    NSMutableString *controlName;
    XCUIApplication *app;
}

- (instancetype)init:(NSString *)controlName;

@end
