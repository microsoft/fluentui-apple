// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#if __has_include(<AppCenterDistribute/MSACReleaseDetails.h>)
#import <AppCenterDistribute/MSACReleaseDetails.h>
#else
#import "MSACReleaseDetails.h"
#endif

#import <AuthenticationServices/AuthenticationServices.h>

@class MSACDistribute;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DistributeDelegate)
@protocol MSACDistributeDelegate <NSObject>

@optional

/**
 * Callback method that will be called whenever a new release is available for update.
 *
 * @param distribute The instance of MSACDistribute.
 * @param details Release details for the update.
 *
 * @return Return YES if you want to take update control by overriding default update dialog, NO otherwise.
 *
 * @see [MSACDistribute notifyUpdateAction:]
 */
- (BOOL)distribute:(MSACDistribute *)distribute releaseAvailableWithDetails:(MSACReleaseDetails *)details;

/**
 * Callback method that will be called whenever update check reports that there is no new release available for update.
 *
 * @param distribute The instance of MSACDistribute.
 */
- (void)distributeNoReleaseAvailable:(MSACDistribute *)distribute;

/**
 * Callback method that will be called before the app is permanently closed for update.
 * It is the right place to add any required clean ups.
 *
 * @param distribute The instance of MSACDistribute.
 */
- (void)distributeWillExitApp:(MSACDistribute *)distribute;

@end

NS_ASSUME_NONNULL_END
