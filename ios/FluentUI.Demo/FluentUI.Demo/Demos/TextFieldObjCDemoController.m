//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "TextFieldObjCDemoController.h"
#import <FluentUI/FluentUI-Swift.h>

@implementation TextFieldObjCDemoController

- (void)loadView {
    [super loadView];
    
    MSFTextField *textField1 = [[MSFTextField alloc] init];
    [textField1 setPlaceholder:@"Validates text on each input character"];
    [textField1 setLeadingImage:[UIImage imageNamed:@"Placeholder_24"]];
    [textField1 setOnEditingChanged:^(MSFTextField *textfield){
        [self onEditingChanged:textfield];
    }];

    MSFTextField *textField2 = [[MSFTextField alloc] init];
    [textField2 setPlaceholder:@"Hint text"];
    [textField2 setLeadingImage:[UIImage imageNamed:@"Placeholder_24"]];
    [textField2 setTitleText:@"Changes leading image on selection"];
    [textField2 setAssistiveText:@"Validates text on selection and deselection"];
    [textField2 setOnDidBeginEditing:^(MSFTextField *textfield){
        [self onDidBeginEditing:textfield];
    }];
    [textField2 setOnDidEndEditing:^(MSFTextField *textfield){
        [self onDidEndEditing:textfield];
    }];

    MSFTextField *textField3 = [[MSFTextField alloc] init];
    [textField3 setPlaceholder:@"Hint text"];
    [textField3 setAssistiveText:@"Validates on press of return key"];
    [textField3 setOnReturn:^ BOOL (MSFTextField *textfield) {
        return [self onReturn:textfield];
    }];

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[textField1, textField2, textField3]];
    [stack setAxis:UILayoutConstraintAxisVertical];
    [stack setSpacing:20];
    [stack setDistribution:UIStackViewDistributionEqualSpacing];
    [stack setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *view = [self view];
    [view addSubview:stack];
    MSFAliasTokens *aliasTokens = [[view fluentTheme] aliasTokens];
    MSFDynamicColor *background1 = [aliasTokens aliasColorForToken:MSFColorAliasTokensBackground1];
    [view setBackgroundColor:[[UIColor alloc] initWithDynamicColor:background1]];

    UILayoutGuide *safeArea = [view safeAreaLayoutGuide];
    [NSLayoutConstraint activateConstraints:@[
        [[safeArea topAnchor] constraintEqualToAnchor:[stack topAnchor]],
        [[safeArea leadingAnchor] constraintEqualToAnchor:[stack leadingAnchor]],
        [[safeArea trailingAnchor] constraintEqualToAnchor:[stack trailingAnchor]]
    ]];
}

- (MSFTextInputError *_Nullable)validateText:(MSFTextField *)textfield {
    NSString *text = [textfield inputText];
    if (text == nil) {
        return [[MSFTextInputError alloc] initWithLocalizedDescription:@"Input text must exist?"];
    }
    if ([text containsString:@"/"]) {
        return [[MSFTextInputError alloc] initWithLocalizedDescription:@"Input text cannot contain the following characters: /"];
    }
    return nil;
}

- (void)onEditingChanged:(MSFTextField *)textfield {
    [textfield setError:[self validateText:textfield]];
}

- (void)onDidBeginEditing:(MSFTextField *)textfield {
    [textfield setLeadingImage:[[UIImage imageNamed:@"play-in-circle-24x24"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [textfield setError:[self validateText:textfield]];
}

- (void)onDidEndEditing:(MSFTextField *)textfield {
    [textfield setLeadingImage:[UIImage imageNamed:@"Placeholder_24"]];
    [textfield setError:[self validateText:textfield]];
}

- (BOOL)onReturn:(MSFTextField *)textfield {
    MSFTextInputError *error = [self validateText:textfield];
    [textfield setError:error];
    return error != nil;
}
@end
