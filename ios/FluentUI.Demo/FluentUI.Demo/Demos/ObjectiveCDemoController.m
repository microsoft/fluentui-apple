//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"
#import "ObjectiveCDemoColorProviding.h"
#import <FluentUI/FluentUI-Swift.h>
#import <FluentUI_Demo-Swift.h>

@interface ObjectiveCDemoController () <MSFTwoLineTitleViewDelegate,
                                        UIPopoverPresentationControllerDelegate>

@property (nonatomic) MSFTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;
@property (nonatomic) MSFButton *testButton;

@property (nonatomic) UIViewController *appearanceController; // Type-erased to UIViewController because UIHostingController subclasses can't be represented directly in @objc

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

    MSFButtonLegacy *testTokensButton = [self createButtonWithTitle:@"Test global and alias" action:@selector(tokensButtonPressed:)];
    [self.container addArrangedSubview:testTokensButton];


    MSFButtonLegacy *testOverridesButton = [self createButtonWithTitle:@"Test overrides" action:@selector(overridesButtonPressed:)];
    [self.container addArrangedSubview:testOverridesButton];

    UILabel *buttonVnextLabel = [[UILabel alloc] init];
    [buttonVnextLabel setText:@"Button (Vnext)"];
    [self.container addArrangedSubview:buttonVnextLabel];

    _testButton = [[MSFButton alloc] initWithStyle:MSFButtonStyleSecondary
                                              size:MSFButtonSizeMedium
                                            action:^(MSFButton *sender) {}];
    [self resetButton];
    [self.container addArrangedSubview:_testButton];

    MSFButtonLegacy *enableButton = [self createButtonWithTitle:@"Enable Button" action:@selector(enableButton)];
    [self.container addArrangedSubview:enableButton];

    MSFButtonLegacy *disableButton = [self createButtonWithTitle:@"Disable Button" action:@selector(disableButton)];
    [self.container addArrangedSubview:disableButton];

    MSFButtonLegacy *resetButton = [self createButtonWithTitle:@"Reset Button" action:@selector(resetButton)];
    [self.container addArrangedSubview:resetButton];

    UILabel *listVnextLabel = [[UILabel alloc] init];
    [listVnextLabel setText:@"List (vNext)"];
    [self.container addArrangedSubview:listVnextLabel];

    MSFList *testList = [[MSFList alloc] init];
    id<MSFListSectionState> sectionState = [[testList state] createSection];
    id<MSFListCellState> listCell1 = [sectionState createCell];
    id<MSFListCellState> listCell2 = [sectionState createCell];
    id<MSFListCellState> listCell3 = [sectionState createCell];

    id<MSFListCellState> childCell = [listCell1 createChildCell];
    [childCell setTitle:@"Child Cell"];

    [listCell1 setTitle:@"SampleTitle1"];
    [listCell1 setIsExpanded:TRUE];

    [listCell2 setTitle:@"SampleTitle2"];
    [listCell2 setSubtitle:@"SampleTitle2"];
    [listCell2 setLayoutType:MSFListCellLayoutTypeTwoLines];
    [listCell2 setOnTapAction:^{
        [self showAlertForCellTapped:@"SampleTitle2"];
    }];

    [listCell3 setTitle:@"SampleTitle3"];
    [listCell3 setSubtitle:@"SampleTitle3"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"excelIcon"]];
    [listCell3 setLeadingUIView:image];
    [listCell3 setAccessoryType:MSFListAccessoryTypeDisclosure];
    [listCell3 setLayoutType:MSFListCellLayoutTypeTwoLines];
    [listCell3 setOnTapAction:^{
        [self showAlertForCellTapped:@"Sample Title3"];
    }];

    testList.translatesAutoresizingMaskIntoConstraints = false;

    [self.container addArrangedSubview:testList];

    [[[testList heightAnchor] constraintEqualToConstant:250] setActive:YES];

    [self setAddedLabels:[NSMutableSet set]];

    [self setAppearanceController:[MSFDemoAppearanceControllerWrapper createDemoAppearanceControllerWithDelegate:nil]];
    [self configureAppearancePopover];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(themeDidChange:)
                                                 name: @"FluentUI.stylesheet.theme"
                                               object: nil];
}

- (void)enableButton {
    id<MSFButtonState> state = [self->_testButton state];
    [state setText:@"Enabled"];
    [state setIsDisabled:NO];
    [state setImage:[UIImage imageNamed:@"Placeholder_20"]];
}

- (void)disableButton {
    id<MSFButtonState> state = [self->_testButton state];
    [state setText:@"Disabled"];
    [state setIsDisabled:YES];
    [state setImage:nil];
}

- (void)resetButton {
    id<MSFButtonState> state = [self->_testButton state];
    [state setText:@"Button (Vnext)"];
    [state setImage:nil];
    [state setIsDisabled:NO];
}

- (MSFButtonLegacy *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    MSFButtonLegacy* button = [[MSFButtonLegacy alloc] init];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)showAlertForCellTapped:(NSString *)title {
    NSString *message = [NSString stringWithFormat:@"%@ was pressed", title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
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
    MSFColorValue *colorValue = [MSFGlobalTokens sharedColorForColorSet:MSFSharedColorSetsPink
                                                                  token:MSFSharedColorsTokensPrimary];
    [self addLabelWithText:@"Test label with global color"
                 textColor:[[UIColor alloc] initWithColorValue:colorValue]];

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
    [self.titleView setupWithTitle:self.title subtitle:nil interactivePart:MSFTwoLineTitleViewInteractivePartTitle accessoryType:MSFTwoLineTitleViewAccessoryTypeNone];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
}

- (void)addTitleWithText:(NSString*)text {
    MSFLabel* titleLabel = [[MSFLabel alloc] initWithTextStyle:MSFTypographyTokenBody1
                                                    colorStyle:MSFTextColorStyleRegular];
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
