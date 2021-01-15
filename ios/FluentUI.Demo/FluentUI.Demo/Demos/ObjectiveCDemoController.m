//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"

@interface ObjectiveCDemoController () <MSFTwoLineTitleViewDelegate>

@property (nonatomic) MSFTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;
@property (nonatomic) MSFButtonVnext *testButtonVnext;

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

    MSFButton *testButton = [self createButtonWithTitle:@"Test" action:nil];
    [self.container addArrangedSubview:testButton];

    UILabel *buttonVnextLabel = [[UILabel alloc] init];
    [buttonVnextLabel setText:@"Button (vNext)"];
    [self.container addArrangedSubview:buttonVnextLabel];

    _testButtonVnext = [[MSFButtonVnext alloc] initWithStyle:MSFButtonVnextStyleSecondary
                                                        size:MSFButtonVnextSizeMedium
                                                      action:^(MSFButtonVnext *sender) {}];
    [self resetVnextButton];
    [self.container addArrangedSubview:[_testButtonVnext view]];

    MSFButton *enableButton = [self createButtonWithTitle:@"Enable Vnext Button" action:@selector(enableVnextButton)];
    [self.container addArrangedSubview:enableButton];

    MSFButton *disableButton = [self createButtonWithTitle:@"Disable Vnext Button" action:@selector(disableVnextButton)];
    [self.container addArrangedSubview:disableButton];

    MSFButton *resetButton = [self createButtonWithTitle:@"Reset Vnext Button" action:@selector(resetVnextButton)];
    [self.container addArrangedSubview:resetButton];
    
    UILabel *listVnextLabel = [[UILabel alloc] init];
    [listVnextLabel setText:@"List (vNext)"];
    [self.container addArrangedSubview:listVnextLabel];

    MSFListVnextCellData *childCell = [[MSFListVnextCellData alloc] init];
    [childCell setTitle:@"SampleTitle1"];
    NSArray *children = [NSArray arrayWithObject:childCell];

    MSFListVnextCellData *listCell1 = [[MSFListVnextCellData alloc] init];
    [listCell1 setTitle:@"SampleTitle1"];
    [listCell1 setChildren:children];

    MSFListVnextCellData *listCell2 = [[MSFListVnextCellData alloc] init];
    [listCell2 setTitle:@"SampleTitle2"];
    [listCell2 setSubtitle:@"SampleTitle2"];
    [listCell2 setOnTapAction:^{
        [self showAlertForCellTapped:@"SampleTitle2"];
    }];

    MSFListVnextCellData *listCell3 = [[MSFListVnextCellData alloc] init];
    [listCell3 setTitle:@"SampleTitle3"];
    [listCell3 setSubtitle:@"SampleTitle3"];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"excelIcon"]] ;
    [listCell3 setLeadingView:image];
    [listCell3 setAccessoryType:MSFListAccessoryTypeDisclosure];
    [listCell3 setOnTapAction:^{
        [self showAlertForCellTapped:@"Sample Title3"];
    }];

    MSFListVnextSectionData *section = [[MSFListVnextSectionData alloc] init];
    [section setLayoutType:MSFListCellVnextHeightTwoLines];
    [section setCells:@[listCell1, listCell2, listCell3]];
    NSArray *sections = @[section];

    MSFListVnext *list = [[MSFListVnext alloc] initWithSections:sections iconStyle:MSFListIconVnextStyleNone];

    UIView *listView = [list view];
    listView.translatesAutoresizingMaskIntoConstraints = false;

    [self.container addArrangedSubview:[list view]];

    [[[listView heightAnchor] constraintEqualToConstant:250] setActive:YES];
}

- (void)enableVnextButton {
    MSFButtonVnextState *state = [self->_testButtonVnext state];
    [state setText:@"Enabled"];
    [state setIsDisabled:NO];
    [state setImage:[UIImage imageNamed:@"Placeholder_20"]];
}

- (void)disableVnextButton {
    MSFButtonVnextState *state = [self->_testButtonVnext state];
    [state setText:@"Disabled"];
    [state setIsDisabled:YES];
    [state setImage:nil];
}

- (void)resetVnextButton {
    MSFButtonVnextState *state = [self->_testButtonVnext state];
    [state setText:@"Button VNext"];
    [state setImage:nil];
    [state setIsDisabled:NO];
}

- (MSFButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    MSFButton* button = [[MSFButton alloc] init];
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
