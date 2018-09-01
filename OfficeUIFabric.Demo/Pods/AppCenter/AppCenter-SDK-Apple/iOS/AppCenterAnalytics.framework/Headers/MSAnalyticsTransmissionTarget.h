#import <Foundation/Foundation.h>

#import "MSPropertyConfigurator.h"
#import "MSAnalyticsAuthenticationProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSAnalyticsTransmissionTarget : NSObject

/**
 * Property configurator.
 */
@property(nonatomic, readonly) MSPropertyConfigurator *propertyConfigurator;

+ (void)addAuthenticationProvider:(MSAnalyticsAuthenticationProvider *)authenticatioProvider NS_SWIFT_NAME(addAuthenticationProvider(authenticationProvider:));

/**
 * Track an event.
 *
 * @param eventName  event name.
 */
- (void)trackEvent:(NSString *)eventName;

/**
 * Track an event.
 *
 * @param eventName  event name.
 * @param properties dictionary of properties.
 */
- (void)trackEvent:(NSString *)eventName
    withProperties:(nullable NSDictionary<NSString *, NSString *> *)properties;

/**
 * Get a nested transmission target.
 *
 * @param token The token of the transmission target to retrieve.
 *
 * @returns A transmission target object nested to this parent transmission
 * target.
 */
- (MSAnalyticsTransmissionTarget *)transmissionTargetForToken:(NSString *)token
    NS_SWIFT_NAME(transmissionTarget(forToken:));

/**
 * Enable or disable this transmission target. It will also enable or disable
 * nested transmission targets.
 *
 * @param isEnabled YES to enable, NO to disable.
 * @see isEnabled
 */
- (void)setEnabled:(BOOL)isEnabled;

/**
 * Check whether this transmission target is enabled or not.
 *
 * @return YES if enabled, NO otherwise.
 * @see setEnabled:
 */
- (BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
