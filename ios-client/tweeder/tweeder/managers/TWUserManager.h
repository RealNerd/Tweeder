//
//  TWUserManager.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWUserManager : NSObject
@property (readonly) NSString *loggedInUsername;
@property (readonly) BOOL      isLoggedIn;

+ (TWUserManager *)shared;

- (void)createNewUserAccount:(NSString *)username
                    password:(NSString *)password
                       block:(void (^)(BOOL success, NSError *error))block;

- (void)loginToUserAccount:(NSString *)username
                  password:(NSString *)password
                     block:(void (^)(BOOL success, NSError *error))block;

- (void)fetchNewMessagesForCurrentUserWithBlock:(void (^)(NSArray *newMessages, NSError *error))block;

- (void)postNewMessageForCurrentUser:(NSString *)newMessage
                               block:(void (^)(BOOL success, NSError *error))block;

- (void)logout;

@end
