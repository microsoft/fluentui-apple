//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"
#import <FluentUI/FluentUI-Swift.h>

@interface ObjectiveCDemoController () <MSFTwoLineTitleViewDelegate>

@property (nonatomic) MSFTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;

@end

@implementation ObjectiveCDemoController

- (void)viewDidLoad {
    [super viewDidLoad];

    MSFTwoLineTitleView *titleView = [[MSFTwoLineTitleView alloc] initWithStyle:MSFTwoLineTitleViewStyleDark];
    [titleView setupWithTitle:self.title subtitle:nil interactivePart:MSFTwoLineTitleViewInteractivePartTitle accessoryType:MSFTwoLineTitleViewAccessoryTypeNone];
    [titleView setDelegate:self];
    [[self navigationItem] setTitleView:titleView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:MSFColors.surfacePrimary];

    MSFLabel *buttonLabel = [[MSFLabel alloc] initWithStyle:MSFTextStyleHeadline colorStyle:MSFTextColorStyleRegular];
    [buttonLabel setText:@"Button"];

    MSFButton *button = [[MSFButton alloc] initWithStyle:MSFButtonStyleSecondary
                                                    size:MSFButtonSizeMedium
                                                  action:^(MSFButton *sender){
        [self showButtonPressAlert];
    }];
    [[button state] setText:@"Button"];

    UIStackView *verticalContainer = [[UIStackView alloc] initWithArrangedSubviews:@[buttonLabel, [button view]]];
    [verticalContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [verticalContainer setAxis:UILayoutConstraintAxisVertical];
    [verticalContainer setSpacing:16];
    [verticalContainer setLayoutMargins:UIEdgeInsetsMake(16, 16, 16, 16)];
    [verticalContainer setLayoutMarginsRelativeArrangement:YES];

    UIScrollView *scrollingContainer = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [scrollingContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollingContainer addSubview:verticalContainer];
    [view addSubview:scrollingContainer];

    [NSLayoutConstraint activateConstraints:@[
        [[scrollingContainer topAnchor] constraintEqualToAnchor:[view topAnchor]],
        [[scrollingContainer bottomAnchor] constraintEqualToAnchor:[view bottomAnchor]],
        [[scrollingContainer leadingAnchor] constraintEqualToAnchor:[view leadingAnchor]],
        [[scrollingContainer trailingAnchor] constraintEqualToAnchor:[view trailingAnchor]],
        
        [[verticalContainer topAnchor] constraintEqualToAnchor:[scrollingContainer topAnchor]],
        [[verticalContainer bottomAnchor] constraintEqualToAnchor:[scrollingContainer bottomAnchor]],
        [[verticalContainer leadingAnchor] constraintEqualToAnchor:[scrollingContainer leadingAnchor]],
        [[verticalContainer trailingAnchor] constraintEqualToAnchor:[scrollingContainer trailingAnchor]]
    ]];

    [self setView:view];
}

- (void)showButtonPressAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Button was pressed"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionDismiss = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(__unused UIAlertAction *action){
    }];
    [alert addAction:actionDismiss];
    [[[[self view] window] rootViewController] presentViewController:alert
                                                     animated:YES
                                                   completion:nil];
}

#pragma mark MSFTwoLineTitleViewDelegate

- (void)twoLineTitleViewDidTapOnTitle:(MSFTwoLineTitleView *)twoLineTitleView {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"The title button was pressed" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

@end
