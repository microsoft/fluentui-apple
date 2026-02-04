//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoColorProviding.h"
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

/// MARK: ColorProviding

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

/// MARK: BrandColorProviding

- (UIColor *)brand10 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand10Color"];
}

- (UIColor *)brand20 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand20Color"];
}

- (UIColor *)brand30 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand30Color"];
}

- (UIColor *)brand40 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand40Color"];
}

- (UIColor *)brand50 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand50Color"];
}

- (UIColor *)brand60 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand60Color"];
}

- (UIColor *)brand70 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand70Color"];
}

- (UIColor *)brand80 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand80Color"];
}

- (UIColor *)brand90 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand90Color"];
}

- (UIColor *)brand100 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand100Color"];
}

- (UIColor *)brand110 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand110Color"];
}

- (UIColor *)brand120 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand120Color"];
}

- (UIColor *)brand130 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand130Color"];
}

- (UIColor *)brand140 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand140Color"];
}

- (UIColor *)brand150 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand150Color"];
}

- (UIColor *)brand160 {
    return [UIColor colorNamed:@"Colors/DemoGreenBrand160Color"];
}

@end
