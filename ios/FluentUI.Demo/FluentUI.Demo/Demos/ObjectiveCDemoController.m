//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"

@interface ObjectiveCDemoController () <MSFTwoLineTitleViewDelegate>

@property (nonatomic) MSFTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;
@property (nonatomic) MSFButton *testButton;

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

    UILabel *buttonLabel = [[UILabel alloc] init];
    [buttonLabel setText:@"Button"];
    [self.container addArrangedSubview:buttonLabel];

    MSFButtonLegacy *testButton = [self createButtonWithTitle:@"Test" action:nil];
    [self.container addArrangedSubview:testButton];

    UILabel *buttonVnextLabel = [[UILabel alloc] init];
    [buttonVnextLabel setText:@"Button (Vnext)"];
    [self.container addArrangedSubview:buttonVnextLabel];

    _testButton = [[MSFButton alloc] initWithStyle:MSFButtonStyleSecondary
                                              size:MSFButtonSizeMedium
                                            action:^(MSFButton *sender) {}];
    [self resetButton];
    [self.container addArrangedSubview:[_testButton view]];

    MSFButtonLegacy *enableButton = [self createButtonWithTitle:@"Enable Button" action:@selector(enableButton)];
    [self.container addArrangedSubview:enableButton];

    MSFButtonLegacy *disableButton = [self createButtonWithTitle:@"Disable Button" action:@selector(disableButton)];
    [self.container addArrangedSubview:disableButton];

    MSFButtonLegacy *resetButton = [self createButtonWithTitle:@"Reset Button" action:@selector(resetButton)];
    [self.container addArrangedSubview:resetButton];
    
    UILabel *listVnextLabel = [[UILabel alloc] init];
    [listVnextLabel setText:@"List (vNext)"];
    [self.container addArrangedSubview:listVnextLabel];

    MSFListCellState *childCell = [[MSFListCellState alloc] init];
    [childCell setTitle:@"Child Cell"];
    NSArray *children = [NSArray arrayWithObject:childCell];

    MSFListCellState *listCell1 = [[MSFListCellState alloc] init];
    [listCell1 setTitle:@"SampleTitle1"];
    [listCell1 setIsExpanded:TRUE];
    [listCell1 setChildren:children];

    MSFListCellState *listCell2 = [[MSFListCellState alloc] init];
    [listCell2 setTitle:@"SampleTitle2"];
    [listCell2 setSubtitle:@"SampleTitle2"];
    [listCell2 setLayoutType:MSFListCellLayoutTypeTwoLines];
    [listCell2 setOnTapAction:^{
        [self showAlertForCellTapped:@"SampleTitle2"];
    }];

    MSFListCellState *listCell3 = [[MSFListCellState alloc] init];
    [listCell3 setTitle:@"SampleTitle3"];
    [listCell3 setSubtitle:@"SampleTitle3"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"excelIcon"]] ;
    [listCell3 setLeadingView:image];
    [listCell3 setAccessoryType:MSFListAccessoryTypeDisclosure];
    [listCell3 setLayoutType:MSFListCellLayoutTypeTwoLines];
    [listCell3 setOnTapAction:^{
        [self showAlertForCellTapped:@"Sample Title3"];
    }];

    MSFListSectionState *section = [[MSFListSectionState alloc] init];
    [section setCells:@[listCell1, listCell2, listCell3]];
    NSArray *sections = @[section];

    MSFList *list = [[MSFList alloc] initWithSections:sections iconStyle:MSFListIconStyleNone];

    UIView *listView = [list view];
    listView.translatesAutoresizingMaskIntoConstraints = false;

    [self.container addArrangedSubview:[list view]];

    [[[listView heightAnchor] constraintEqualToConstant:250] setActive:YES];
}

- (void)enableButton {
    MSFButtonState *state = [self->_testButton state];
    [state setText:@"Enabled"];
    [state setIsDisabled:NO];
    [state setImage:[UIImage imageNamed:@"Placeholder_20"]];
}

- (void)disableButton {
    MSFButtonState *state = [self->_testButton state];
    [state setText:@"Disabled"];
    [state setIsDisabled:YES];
    [state setImage:nil];
}

- (void)resetButton {
    MSFButtonState *state = [self->_testButton state];
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

- (UIStackView *)createVerticalContainer {
    UIStackView* container = [[UIStackView alloc] initWithFrame:CGRectZero];
    container.axis = UILayoutConstraintAxisVertical;
    container.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16);
    container.layoutMarginsRelativeArrangement = YES;
    container.spacing = 16;
    return container;
}

- (void)setupTitleView {
    self.titleView = [[MSFTwoLineTitleView alloc] initWithStyle:MSFTwoLineTitleViewStyleDark];
    [self.titleView setupWithTitle:self.title subtitle:nil interactivePart:MSFTwoLineTitleViewInteractivePartTitle accessoryType:MSFTwoLineTitleViewAccessoryTypeNone];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
}

- (void)addTitleWithText:(NSString*)text {
    MSFLabel* titleLabel = [[MSFLabel alloc] initWithStyle:MSFTextStyleHeadline colorStyle:MSFTextColorStyleRegular];
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.container addArrangedSubview:titleLabel];
}

#pragma mark MSFTwoLineTitleViewDelegate

- (void)twoLineTitleViewDidTapOnTitle:(MSFTwoLineTitleView *)twoLineTitleView {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"The title button was pressed" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

@end
