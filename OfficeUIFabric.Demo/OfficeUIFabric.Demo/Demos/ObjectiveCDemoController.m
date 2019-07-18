//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "ObjectiveCDemoController.h"

@interface ObjectiveCDemoController () <MSTwoLineTitleViewDelegate>

@property (nonatomic) MSTwoLineTitleView *titleView;
@property (nonatomic) UIStackView *container;
@property (nonatomic) UIScrollView *scrollingContainer;

@end

@implementation ObjectiveCDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.container = [self createVerticalContainer];
    self.scrollingContainer = [[UIScrollView alloc] initWithFrame:CGRectZero];

    self.view.backgroundColor = MSColors.background1;
    [self setupTitleView];

    [self.view addSubview:self.scrollingContainer];
    [self.scrollingContainer fitIntoSuperview];
    [self.scrollingContainer addSubview:self.container];
    // UIScrollView in RTL mode still have leading on the left side, so we cannot rely on leading/trailing-based constraints
    [self.container fitIntoSuperviewUsingConstraints:true usingLeadingTrailing:false margins:UIEdgeInsetsZero autoWidth:false autoHeight:true];
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
    self.titleView = [[MSTwoLineTitleView alloc] initWithStyle: MSTwoLineTitleViewStyleDark];
    [self.titleView setupWithTitle:self.title subtitle:nil interactivePart:MSTwoLineTitleViewInteractivePartTitle accessoryType:MSTwoLineTitleViewAccessoryTypeNone];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
}

- (MSButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    MSButton* button = [[MSButton alloc] init];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addTitleWithText:(NSString*)text {
    MSLabel* titleLabel = [[MSLabel alloc] initWithStyle:MSTextStyleHeadline colorStyle:MSTextColorStyleRegular];
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.container addArrangedSubview:titleLabel];
}

#pragma mark MSTwoLineTitleViewDelegate

- (void)twoLineTitleViewDidTapOnTitle:(MSTwoLineTitleView *)twoLineTitleView {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"The title button was pressed" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

@end
