// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#if __has_include(<AppCenter/MSACServiceAbstract.h>)
#import <AppCenter/MSACServiceAbstract.h>
#else
#import "MSACServiceAbstract.h"
#endif

#if __has_include(<AppCenterDistribute/MSACDistributeDelegate.h>)
#import <AppCenterDistribute/MSACDistributeDelegate.h>
#else
#import "MSACDistributeDelegate.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 * App Center Distribute service.
 */
NS_SWIFT_NAME(Distribute)
@interface MSACDistribute : MSACServiceAbstract

typedef NS_ENUM(NSInteger, MSACUpdateAction) {

  /**
   * Action to trigger update.
   */
  MSACUpdateActionUpdate,

  /**
   * Action to postpone update.
   */
  MSACUpdateActionPostpone
} NS_SWIFT_NAME(UpdateAction);

typedef NS_ENUM(NSInteger, MSACUpdateTrack) {

  /**
   * An update track for tracking public updates.
   */
  MSACUpdateTrackPublic = 1,

  /**
   * An update track for tracking updates sent to private groups.
   */
  MSACUpdateTrackPrivate = 2
} NS_SWIFT_NAME(UpdateTrack);

/**
 * Update track.
 */
@property(class, nonatomic) MSACUpdateTrack updateTrack;

/**
 * Distribute delegate
 *
 * @discussion If Distribute delegate is set and releaseAvailableWithDetails is returning <code>YES</code>, you must call
 * notifyUpdateAction: with one of update actions to handle a release properly.
 *
 * @see releaseAvailableWithDetails:
 * @see notifyUpdateAction:
 */
@property(class, nonatomic, weak) id<MSACDistributeDelegate> _Nullable delegate;

/**
 * URL that is used for generic update related tasks.
 */
@property(class, nonatomic, copy, setter=setApiUrl:) NSString *apiUrl;

/**
 * URL that is used to install update.
 *
 */
@property(class, nonatomic, copy, setter=setInstallUrl:) NSString *installUrl;

/**
 * Notify SDK with an update action to handle the release.
 */
+ (void)notifyUpdateAction:(MSACUpdateAction)action;

/**
 * Process URL request for the service.
 *
 * @param url  The url with parameters.
 *
 * @return `YES` if the URL is intended for App Center Distribute and your application, `NO` otherwise.
 *
 * @discussion Place this method call into your app delegate's openURL method.
 */
+ (BOOL)openURL:(NSURL *)url;

/**
 * Disable checking the latest release of the application when the SDK starts.
 */
+ (void)disableAutomaticCheckForUpdate;

/**
 * Check for the latest release using the selected update track.
 */
+ (void)checkForUpdate;

@end

NS_ASSUME_NONNULL_END
