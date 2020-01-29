// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSUserInformation : NSObject

/**
 * The account identifier for the user.
 */
@property(nonatomic, copy) NSString *accountId;

/**
 * Create user with account identifier.
 *
 * @param accountId account identifier for the user.
 *
 * @return user with account identifier.
 */
- (instancetype)initWithAccountId:(NSString *)accountId;
@end

NS_ASSUME_NONNULL_END
