//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"
#import "ObjectiveCDemoColorProviding.h"
#import <FluentUI_Demo-Swift.h>

@interface ObjectiveCDemoController () <MSFTwoLineTitleViewDelegate,
                                        UIPopoverPresentationControllerDelegate>

@property (nonatomic) MSFTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;

@property (nonatomic) MSFDemoAppearanceControlView *appearanceControlView;

@property (nonatomic) NSMutableSet<UILabel *> *addedLabels;

@property (nonatomic) ObjectiveCDemoColorProviding *colorProvider;

@end

@implementation ObjectiveCDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.container = [self createVerticalContainer];
    self.scrollingContainer = [[UIScrollView alloc] initWithFrame:CGRectZero];

    UIColor *primaryColor = [[[self view] fluentTheme] colorForToken:MSFColorTokenBackground1];
    self.view.backgroundColor = primaryColor;
    [self setupTitleView];

    [self.view addSubview:self.scrollingContainer];
    [self.scrollingContainer setFrame:self.view.bounds];
    [self.scrollingContainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    [self.scrollingContainer addSubview:self.container];
    // UIScrollView in RTL mode still have leading on the left side, so we cannot rely on leading/trailing-based constraints
    [self.container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[self.container topAnchor] constraintEqualToAnchor:[self.scrollingContainer topAnchor]],
        [[self.container bottomAnchor] constraintEqualToAnchor:[self.scrollingContainer bottomAnchor]],
        [[self.container leftAnchor] constraintEqualToAnchor:[self.scrollingContainer leftAnchor]],
        [[self.container widthAnchor] constraintEqualToAnchor:[self.scrollingContainer widthAnchor]],
    ]];

    MSFButton *testTokensButton = [self createButtonWithTitle:@"Test global and alias" action:@selector(tokensButtonPressed:)];
    [self.container addArrangedSubview:testTokensButton];


    MSFButton *testOverridesButton = [self createButtonWithTitle:@"Test overrides" action:@selector(overridesButtonPressed:)];
    [self.container addArrangedSubview:testOverridesButton];

    [self setAddedLabels:[NSMutableSet set]];

    [self setAppearanceControlView:[[MSFDemoAppearanceControlView alloc] initWithDelegate:nil]];
    [self configureAppearanceBarButtonItem];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(themeDidChange:)
                                                 name: @"FluentUI.stylesheet.theme"
                                               object: nil];
}

- (void)resetAddedLabels {
    for (UILabel *label in [self addedLabels]) {
        [label removeFromSuperview];
    }
    [[self addedLabels] removeAllObjects];
}

- (void)addLabelWithText:(NSString *)text
               textColor:(UIColor *)textColor {
    MSFLabel *label = [[MSFLabel alloc] initWithTextStyle:MSFTypographyTokenBody1
                                               colorStyle:MSFTextColorStyleRegular];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:text];
    [label setTextColor:textColor];

    [[self container] addArrangedSubview:label];
    [[self addedLabels] addObject:label];
}

- (void)tokensButtonPressed:(id)sender {
    UIColor *color = [MSFGlobalTokens colorForSharedColorSet:MSFGlobalTokensSharedColorSetPink
                                                       token:MSFGlobalTokensSharedColorPrimary];
    [self addLabelWithText:@"Test label with global color"
                 textColor:color];

    // Add alias-colored label too
    MSFFluentTheme *fluentTheme = [[self view] fluentTheme];
    UIColor *primaryColor = [fluentTheme colorForToken:MSFColorTokenBrandForeground1];
    [self addLabelWithText:@"Test label with alias color"
                 textColor:primaryColor];

    // Finally, add a shared-theme brand color (should be comm blue)
    MSFFluentTheme *sharedTheme = [MSFFluentTheme sharedTheme];
    UIColor *sharedPrimaryColor = [sharedTheme colorForToken:MSFColorTokenBrandForeground1];
    [self addLabelWithText:@"Test label with shared alias color"
                 textColor:sharedPrimaryColor];
}

- (void)overridesButtonPressed:(id)sender {
    [[self view] setColorProvider:[[ObjectiveCDemoColorProviding alloc] init]];

    UIColor *primaryColor = [[[self view] fluentTheme] colorForToken:MSFColorTokenBrandForeground1];

    [self addLabelWithText:@"Test label with override brand color"
                 textColor:primaryColor];

    // Remove the overrides
    [[self view] resetFluentTheme];
    primaryColor = [[[self view] fluentTheme] colorForToken:MSFColorTokenBrandForeground1];

    [self addLabelWithText:@"Test label with override color removed"
                 textColor:primaryColor];
}

- (UIStackView *)createVerticalContainer {
    UIStackView* container = [[UIStackView alloc] initWithFrame:CGRectZero];
    container.axis = UILayoutConstraintAxisVertical;
    container.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16);
    container.layoutMarginsRelativeArrangement = YES;
    container.spacing = 16;
    return container;
}

- (void)setupTitleView {
    self.titleView = [[MSFTwoLineTitleView alloc] initWithStyle:MSFTwoLineTitleViewStyleSystem];
    [self.titleView setupWithTitle:self.title
                          subtitle:nil
                   interactivePart:MSFTwoLineTitleViewInteractivePartTitle
                     accessoryType:MSFTwoLineTitleViewAccessoryTypeNone
       customSubtitleTrailingImage:nil
isTitleImageLeadingForTitleAndSubtitle:false];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
}

- (MSFButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    MSFButton* button = [[MSFButton alloc] init];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addTitleWithText:(NSString*)text {
    MSFLabel* titleLabel = [[MSFLabel alloc] initWithTextStyle:MSFTypographyTokenBody1
                                                    colorStyle:MSFTextColorStyleRegular];
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.container addArrangedSubview:titleLabel];
}

#pragma mark Demo Appearance Control

- (void)configureAppearanceBarButtonItem {
    // Display the DemoAppearance button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self appearanceControlView]];
    [[self navigationItem] setRightBarButtonItem:item];
}

- (void)themeDidChange:(NSNotification *)n {
    [self resetAddedLabels];
}

#pragma mark MSFTwoLineTitleViewDelegate

- (void)twoLineTitleViewDidTapOnTitle:(MSFTwoLineTitleView *)twoLineTitleView {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"The title button was pressed" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark UIPopoverPresentationControllerDelegate

/// Overridden to allow for popover-style modal presentation on compact (e.g. iPhone) devices.
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
