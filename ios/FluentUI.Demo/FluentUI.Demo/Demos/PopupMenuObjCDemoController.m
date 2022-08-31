//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "PopupMenuObjCDemoController.h"
#import <FluentUI/FluentUI-Swift.h>

@implementation PopupMenuObjCDemoController

- (instancetype)init {
    self = [super init];
    if (self != nil)
    {
        _selectedCityIndex = [[NSIndexPath alloc] initWithIndex:0];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    MSFButton *demoButton = [[MSFButton alloc] initWithStyle:MSFButtonStylePrimaryOutline];
    [demoButton setTitle:@"Show PopupMenu" forState:UIControlStateNormal];
    [demoButton addTarget:self action:@selector(showPopupMenu) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[demoButton]];
    [stack setAlignment:UIStackViewAlignmentTop];
    [stack setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView *view = [self view];
    [view addSubview:stack];
    [view setBackgroundColor:[MSFColors surfacePrimary]];
    UILayoutGuide *safeArea = [view safeAreaLayoutGuide];
    [NSLayoutConstraint activateConstraints:@[
        [[stack topAnchor] constraintEqualToAnchor:[safeArea topAnchor] constant:10],
        [[stack leadingAnchor] constraintEqualToAnchor:[safeArea leadingAnchor] constant:10],
        [[stack trailingAnchor] constraintEqualToAnchor:[safeArea trailingAnchor] constant:-10],
        [[stack bottomAnchor] constraintEqualToAnchor:[safeArea bottomAnchor] constant:10]
    ]];
}

- (void)showPopupMenu {
    MSFPopupMenuItem *montreal = [[MSFPopupMenuItem alloc] initWithImageName:@"Montreal"
                                                       generateSelectedImage:NO
                                                                       title:@"Montréal"
                                                                    subtitle:@"Québec"
                                                                   isEnabled:YES
                                                                  isSelected:NO
                                                                    executes:MSFPopupMenuItemExecutionModeOnSelection
                                                                  onSelected:nil
                                                 isAccessoryCheckmarkVisible:YES];
    UIImage *torontoImage = [UIImage imageNamed:@"Toronto"];
    MSFPopupMenuItem *toronto = [[MSFPopupMenuItem alloc] initWithImage:torontoImage
                                                          selectedImage:torontoImage
                                                         accessoryImage:nil
                                                                  title:@"Toronto"
                                                               subtitle:@"Ontario"
                                                          accessoryView:nil
                                                              isEnabled:YES
                                                             isSelected:NO
                                                               executes:MSFPopupMenuItemExecutionModeOnSelection
                                                             onSelected:nil
                                            isAccessoryCheckmarkVisible:YES];
    MSFPopupMenuItem *vancouver = [[MSFPopupMenuItem alloc] initWithImageName:@"Vancouver"
                                                        generateSelectedImage:NO
                                                                        title:@"Vancouver"
                                                                     subtitle:@"British Columbia"
                                                                    isEnabled:YES
                                                                   isSelected:NO
                                                                     executes:MSFPopupMenuItemExecutionModeOnSelection
                                                                   onSelected:nil
                                                  isAccessoryCheckmarkVisible:YES];
    MSFPopupMenuItem *lasVegas = [[MSFPopupMenuItem alloc] initWithImageName:@"Las Vegas"
                                                       generateSelectedImage:NO
                                                                       title:@"Las Vegas"
                                                                    subtitle:@"Nevada"
                                                                   isEnabled:YES
                                                                  isSelected:NO
                                                                    executes:MSFPopupMenuItemExecutionModeOnSelection
                                                                  onSelected:nil
                                                 isAccessoryCheckmarkVisible:YES];
    MSFPopupMenuItem *phoenix  = [[MSFPopupMenuItem alloc] initWithImageName:@"Phoenix"
                                                       generateSelectedImage:NO
                                                                       title:@"Phoenix"
                                                                    subtitle:@"Arizona"
                                                                   isEnabled:YES
                                                                  isSelected:NO
                                                                    executes:MSFPopupMenuItemExecutionModeOnSelection
                                                                  onSelected:nil
                                                 isAccessoryCheckmarkVisible:YES];
    MSFPopupMenuItem *sanFrancisco  = [[MSFPopupMenuItem alloc] initWithImageName:@"San Francisco"
                                                            generateSelectedImage:NO
                                                                            title:@"San Francisco"
                                                                         subtitle:@"California"
                                                                        isEnabled:YES
                                                                       isSelected:NO
                                                                         executes:MSFPopupMenuItemExecutionModeOnSelection
                                                                       onSelected:nil
                                                      isAccessoryCheckmarkVisible:YES];
    MSFPopupMenuItem *seattle  = [[MSFPopupMenuItem alloc] initWithImageName:@"Seattle"
                                                       generateSelectedImage:NO
                                                                       title:@"Seattle"
                                                                    subtitle:@"Washington"
                                                                   isEnabled:YES
                                                                  isSelected:NO
                                                                    executes:MSFPopupMenuItemExecutionModeOnSelection
                                                                  onSelected:nil
                                                 isAccessoryCheckmarkVisible:YES];
    MSFPopupMenuSection *canada = [[MSFPopupMenuSection alloc] initWithTitle:@"Canada"
                                                                       items:@[montreal, toronto, vancouver]];
    MSFPopupMenuSection *unitedStates = [[MSFPopupMenuSection alloc] initWithTitle:@"United States"
                                                                             items:@[lasVegas, phoenix, sanFrancisco, seattle]];
    UIView *source = [self view];
    MSFPopupMenuController *popupMenu = [[MSFPopupMenuController alloc] initWithSourceView:source
                                                                                sourceRect:[source bounds]
                                                                        presentationOrigin:-1
                                                                     presentationDirection:MSFDrawerPresentationDirectionDown
                                                                    preferredMaximumHeight:-1];
    [popupMenu addSections:@[canada, unitedStates]];
    [popupMenu setSelectedItemIndexPath:_selectedCityIndex];
    __weak MSFPopupMenuController *weakMenu = popupMenu;
    [popupMenu setOnDismiss:^{
        [self setSelectedCityIndex:[weakMenu selectedItemIndexPath]];
    }];

    [[self navigationController] presentViewController:popupMenu animated:YES completion:nil];
}

@end
