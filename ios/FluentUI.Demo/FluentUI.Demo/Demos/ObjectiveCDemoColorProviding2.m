//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoColorProviding2.h"
#import <FluentUI/FluentUI-Swift.h>
#import <FluentUI_Demo-Swift.h>

@interface ObjectiveCDemoColorProviding2 () <MSFColorProviding2>

@end

@implementation ObjectiveCDemoColorProviding2

- (UIColor * _Nullable)brandBackgroundColor:(MSFFluentTheme * _Nonnull)theme {
    MSFColorValue *lightColor = [MSFGlobalTokens sharedColorForColorSet:MSFSharedColorSetsOrchid
                                                                  token:MSFSharedColorsTokensTint40];
    MSFColorValue *darkColor = [MSFGlobalTokens sharedColorForColorSet:MSFSharedColorSetsOrchid
                                                                  token:MSFSharedColorsTokensShade30];

    MSFDynamicColor *dynamicColor = [[MSFDynamicColor alloc] initWithLight:lightColor
                                                             lightHighContrast:nil
                                                             lightElevated:nil
                                                 lightElevatedHighContrast:nil
                                                                      dark:darkColor
                                                          darkHighContrast:nil
                                                              darkElevated:nil
                                                  darkElevatedHighContrast:nil];

    return [[UIColor alloc] initWithDynamicColor:dynamicColor];
}

- (UIColor * _Nullable)brandForegroundColor:(MSFFluentTheme * _Nonnull)theme {
    MSFColorValue *lightColor = [MSFGlobalTokens sharedColorForColorSet:MSFSharedColorSetsOrchid
                                                                  token:MSFSharedColorsTokensShade30];
    MSFColorValue *darkColor = [MSFGlobalTokens sharedColorForColorSet:MSFSharedColorSetsOrchid
                                                                token:MSFSharedColorsTokensTint40];

    MSFDynamicColor *dynamicColor = [[MSFDynamicColor alloc] initWithLight:lightColor
                                                             lightHighContrast:nil
                                                             lightElevated:nil
                                                 lightElevatedHighContrast:nil
                                                                      dark:darkColor
                                                          darkHighContrast:nil
                                                              darkElevated:nil
                                                  darkElevatedHighContrast:nil];

    return [[UIColor alloc] initWithDynamicColor:dynamicColor];
}

- (UIColor * _Nullable)brandStrokeColor:(MSFFluentTheme * _Nonnull)theme {
    return nil;
}

- (UIColor * _Nullable)brandBackground1For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackground1PressedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackground1SelectedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackground2For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackground2PressedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackground2SelectedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackground3For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackgroundDisabledFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandBackgroundTintFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandBackgroundColor:theme];
}

- (UIColor * _Nullable)brandForeground1For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandForegroundColor:theme];
}

- (UIColor * _Nullable)brandForeground1PressedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandForegroundColor:theme];
}

- (UIColor * _Nullable)brandForeground1SelectedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandForegroundColor:theme];
}

- (UIColor * _Nullable)brandForegroundDisabled1For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandForegroundColor:theme];
}

- (UIColor * _Nullable)brandForegroundDisabled2For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandForegroundColor:theme];
}

- (UIColor * _Nullable)brandForegroundTintFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandForegroundColor:theme];
}

- (UIColor * _Nullable)brandStroke1For:(MSFFluentTheme * _Nonnull)theme {
    return [self brandStrokeColor:theme];
}

- (UIColor * _Nullable)brandStroke1PressedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandStrokeColor:theme];
}

- (UIColor * _Nullable)brandStroke1SelectedFor:(MSFFluentTheme * _Nonnull)theme {
    return [self brandStrokeColor:theme];
}

@end
