#import "MSAnalyticsTransmissionTarget.h"
#import "MSServiceAbstract.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * App Center analytics service.
 */
@interface MSAnalytics : MSServiceAbstract

/**
 * Track an event.
 *
 * @param eventName  event name.
 */
+ (void)trackEvent:(NSString *)eventName;

/**
 * Track an event.
 *
 * @param eventName  event name.
 * @param properties dictionary of properties.
 */
+ (void)trackEvent:(NSString *)eventName
    withProperties:(nullable NSDictionary<NSString *, NSString *> *)properties;

/**
 * Get a transmission target.
 *
 * @param token The token of the transmission target to retrieve.
 *
 * @returns The transmission target object.
 */
+ (MSAnalyticsTransmissionTarget *)transmissionTargetForToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
