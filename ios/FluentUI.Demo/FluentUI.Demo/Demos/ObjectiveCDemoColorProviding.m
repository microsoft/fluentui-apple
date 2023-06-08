//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoColorProviding.h"
#import <FluentUI/FluentUI-Swift.h>
#import <FluentUI_Demo-Swift.h>

@interface ObjectiveCDemoColorProviding () <MSFColorProviding>

@end

@implementation ObjectiveCDemoColorProviding

- (UIColor *)brandBackgroundColor {
    UIColor *lightColor = [MSFGlobalTokens colorForSharedColorSet:MSFGlobalTokensSharedColorSetOrchid
                                                            token:MSFGlobalTokensSharedColorTint40];
    UIColor *darkColor = [MSFGlobalTokens colorForSharedColorSet:MSFGlobalTokensSharedColorSetOrchid
                                                           token:MSFGlobalTokensSharedColorShade30];

    UIColor *dynamicColor = [[UIColor alloc] initWithLight:lightColor
                                                      dark:darkColor];

    return dynamicColor;
}

- (UIColor *)brandForegroundColor {
    UIColor *lightColor = [MSFGlobalTokens colorForSharedColorSet:MSFGlobalTokensSharedColorSetOrchid
                                                            token:MSFGlobalTokensSharedColorShade30];
    UIColor *darkColor = [MSFGlobalTokens colorForSharedColorSet:MSFGlobalTokensSharedColorSetOrchid
                                                           token:MSFGlobalTokensSharedColorTint40];

    UIColor *dynamicColor = [[UIColor alloc] initWithLight:lightColor
                                                      dark:darkColor];

    return dynamicColor;
}

- (UIColor *)brandStrokeColor {
    return nil;
}

- (UIColor *)brandBackground1 {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackground1Pressed {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackground1Selected {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackground2 {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackground2Pressed {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackground2Selected {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackground3 {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackgroundDisabled {
    return [self brandBackgroundColor];
}

- (UIColor *)brandBackgroundTint {
    return [self brandBackgroundColor];
}

- (UIColor *)brandForeground1 {
    return [self brandForegroundColor];
}

- (UIColor *)brandForeground1Pressed {
    return [self brandForegroundColor];
}

- (UIColor *)brandForeground1Selected {
    return [self brandForegroundColor];
}

- (UIColor *)brandForegroundDisabled1 {
    return [self brandForegroundColor];
}

- (UIColor *)brandForegroundDisabled2 {
    return [self brandForegroundColor];
}

- (UIColor *)brandForegroundTint {
    return [self brandForegroundColor];
}

- (UIColor *)brandStroke1 {
    return [self brandStrokeColor];
}

- (UIColor *)brandStroke1Pressed {
    return [self brandStrokeColor];
}

- (UIColor *)brandStroke1Selected {
    return [self brandStrokeColor];
}

- (UIColor *)brandGradient1 {
    return [self brandGradient1];
}

- (UIColor *)brandGradient2 {
    return [self brandGradient2];
}

- (UIColor *)brandGradient3 {
    return [self brandGradient3];
}

@end
