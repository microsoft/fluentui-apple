#import "MSLogWithNameAndProperties.h"

@interface MSEventLog : MSLogWithNameAndProperties

/**
 * Unique identifier for this event.
 */
@property(nonatomic, copy) NSString *eventId;

@end
