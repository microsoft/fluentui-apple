//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"
#import <FluentUI/FluentUI-Swift.h>
#import <FluentUI_Demo-Swift.h>

@interface ObjectiveCDemoController () <MSFTwoLineTitleViewDelegate,
                                        UIPopoverPresentationControllerDelegate>

@property (nonatomic) MSFTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;

@property (nonatomic) UIViewController *appearanceController; // Type-erased to UIViewController because UIHostingController subclasses can't be represented directly in @objc

@property (nonatomic) NSMutableSet<UILabel *> *addedLabels;

@end

@implementation ObjectiveCDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.container = [self createVerticalContainer];
    self.scrollingContainer = [[UIScrollView alloc] initWithFrame:CGRectZero];

    self.view.backgroundColor = MSFColors.surfacePrimary;
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

    MSFButton *testButton = [self createButtonWithTitle:@"Test" action:@selector(buttonPressed:)];
    [self.container addArrangedSubview:testButton];

    [self setAddedLabels:[NSMutableSet set]];

    [self setAppearanceController:[MSFDemoAppearanceControllerWrapper createDemoAppearanceControllerWithDelegate:nil]];
    [self configureAppearancePopover];

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
    MSFLabel *label = [[MSFLabel alloc] initWithStyle:MSFTextStyleHeadline colorStyle:MSFTextColorStyleRegular];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:text];
    [label setTextColor:textColor];

    [[self container] addArrangedSubview:label];
    [[self addedLabels] addObject:label];
}

- (void)buttonPressed:(id)sender {
    MSFColorValue *colorValue = [MSFGlobalTokens sharedColorForColorSet:MSFSharedColorSetsPink
                                                                  token:MSFSharedColorsTokensPrimary];
    [self addLabelWithText:@"Test label with global color"
                 textColor:[[UIColor alloc] initWithColorValue:colorValue]];

    // Add alias-colored label too
    MSFFluentTheme *fluentTheme = [[self view] fluentTheme];
    MSFAliasTokens *aliasTokens = [fluentTheme aliasTokens];
    MSFDynamicColor *primaryColor = [aliasTokens brandColorForToken:MSFBrandColorsAliasTokensPrimary];
    [self addLabelWithText:@"Test label with alias color"
                 textColor:[[UIColor alloc] initWithDynamicColor:primaryColor]];
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
    [self.titleView setupWithTitle:self.title subtitle:nil interactivePart:MSFTwoLineTitleViewInteractivePartTitle accessoryType:MSFTwoLineTitleViewAccessoryTypeNone];
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
    MSFLabel* titleLabel = [[MSFLabel alloc] initWithStyle:MSFTextStyleHeadline colorStyle:MSFTextColorStyleRegular];
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.container addArrangedSubview:titleLabel];
}

#pragma mark Demo Appearance Controller

- (void)configureAppearancePopover {
    // Display the DemoAppearancePopover button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_fluent_settings_24_regular"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(showAppearancePopover:)];
    [[self navigationItem] setRightBarButtonItem:item];
}

- (void)showAppearancePopover:(UIBarButtonItem *)sender {
    [[[self appearanceController] popoverPresentationController] setBarButtonItem:sender];
    [[[self appearanceController] popoverPresentationController] setDelegate:self];
    [self presentViewController:[self appearanceController]
                       animated:YES
                     completion:nil];
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
