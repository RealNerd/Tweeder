//
//  TWUserManager.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "TWUserManager.h"
#import "TWGeneralUtilities.h"
#import "TWApiManager.h"
#import "NSString+TweederUtilities.h"

// User displayed strings
#define kUserManagerErrorMissingUsername NSLocalizedString(@"Username cannot be empty.", @"")
#define kUserManagerErrorMissingPassword NSLocalizedString(@"Password cannot be empty.", @"")
#define kUserManagerErrorNoCurrentUser   NSLocalizedString(@"You must log in.", @"")

// Internal constants including strings not visible to the user
NSString * const kSettingUsername                         = @"com.vikingricks.tweeder.username";
NSString * const kSettingLastMessageRequestedDateTemplate = @"com.vikingricks.tweeder.lastMessageRequestedDateForUser.%@";

@interface TWUserManager()
@property (strong, nonatomic) NSMutableArray *localMessages;
@end

@implementation TWUserManager

#pragma mark - Public methods
- (void)createNewUserAccount:(NSString *)username
                    password:(NSString *)password
                       block:(void (^)(BOOL success, NSError *error))block {

    // First implicitly log out the current user.
    [self clearCurrentUser];
    
    // Check the input parameters.
    if (![TWGeneralUtilities isValidApiStringParameter:username]) {
        if (block) {
            block(NO, [TWGeneralUtilities createAppErrorWithMessage:kUserManagerErrorMissingUsername]);
            return;
        }
    }
    if (![TWGeneralUtilities isValidApiStringParameter:password]) {
        if (block) {
            block(NO, [TWGeneralUtilities createAppErrorWithMessage:kUserManagerErrorMissingPassword]);
            return;
        }
    }
    
    // Attempt creating new user. On success, implicitly login the user.
    __weak typeof(self) weakSelf = self;
    [[TWApiManager shared] apiRequest:@"createAccount" withMethod:@"POST" andParameters:@{@"username": username, @"password": [password md5]} success:^(id responseObject) {
        
        [weakSelf setCurrentUserWithUsername:username];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, nil);
            });
        }
    } failure:^(NSUInteger httpResponseCode, NSError *error) {

        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, error);
            });
        }
    }];
}

- (void)loginToUserAccount:(NSString *)username
                  password:(NSString *)password
                     block:(void (^)(BOOL success, NSError *error))block {
    
    // First implicitly log out the current user.
    [self clearCurrentUser];
    
    // Check the input parameters.
    if (![TWGeneralUtilities isValidApiStringParameter:username]) {
        if (block) {
            block(NO, [TWGeneralUtilities createAppErrorWithMessage:kUserManagerErrorMissingUsername]);
            return;
        }
    }
    if (![TWGeneralUtilities isValidApiStringParameter:password]) {
        if (block) {
            block(NO, [TWGeneralUtilities createAppErrorWithMessage:kUserManagerErrorMissingPassword]);
            return;
        }
    }
    
    // Attempt login user. On success, set the local login variables.
    __weak typeof(self) weakSelf = self;
    [[TWApiManager shared] apiRequest:@"login" withMethod:@"POST" andParameters:@{@"username": username, @"password": [password md5]} success:^(id responseObject) {
        
        [weakSelf setCurrentUserWithUsername:username];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, nil);
            });
        }
    } failure:^(NSUInteger httpResponseCode, NSError *error) {
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, error);
            });
        }
    }];
}

- (void)fetchNewMessagesForCurrentUserWithBlock:(void (^)(BOOL success, NSError *error))block {
    
    // Make sure there is a current user.
    if (!self.loggedInUsername) {
        if (block) {
            block(NO, [TWGeneralUtilities createAppErrorWithMessage:kUserManagerErrorNoCurrentUser]);
            return;
        }
    }
    
    // Get timestamp of last message fetched from the API
    NSString *lastRequestDate = [self getLastMessageRequestDateForCurrentUser];
    
    // Attempt to fetch messages
    __weak typeof(self) weakSelf = self;
    [[TWApiManager shared] apiRequest:@"getMessages" withMethod:@"GET" andParameters:@{@"username": self.loggedInUsername, @"lastRequestDate": lastRequestDate} success:^(id responseObject) {
        
        [weakSelf mergeNewMessages:responseObject];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, nil);
            });
        }
    } failure:^(NSUInteger httpResponseCode, NSError *error) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, error);
            });
        }
    }];
}

- (void)postNewMessageForCurrentUser:(NSString *)newMessage
                               block:(void (^)(BOOL success, NSError *error))block {
    
    // Make sure there is a current user.
    if (!self.loggedInUsername) {
        if (block) {
            block(NO, [TWGeneralUtilities createAppErrorWithMessage:kUserManagerErrorNoCurrentUser]);
            return;
        }
    }
    
    [[TWApiManager shared] apiRequest:@"postMessage" withMethod:@"POST" andParameters:@{@"username": self.loggedInUsername, @"message": newMessage} success:^(id responseObject) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, nil);
            });
        }
    } failure:^(NSUInteger httpResponseCode, NSError *error) {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, error);
            });
        }
    }];
}

- (void)setLastMessageRequestDateForCurrentUser:(NSString *)lastMessageRequestDate {
    
    NSString *key = [NSString stringWithFormat:kSettingLastMessageRequestedDateTemplate, self.loggedInUsername ?: @"none"];
    [[NSUserDefaults standardUserDefaults] setObject:lastMessageRequestDate forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logout {
    
    [self clearCurrentUser];
}

- (NSArray *)messages {
    
    return [NSArray arrayWithArray:self.localMessages];
}

#pragma mark - initialization methods
- (id)init {
    
    self = [super init];
    if (self) {
        _isLoggedIn = NO;
        _loggedInUsername = nil;
        
        [self attemptAutoLogin];
    }
    return self;
}

#pragma mark - Internal/Private methods
- (void)attemptAutoLogin {
    
    // load last logged-in username from settings
    NSString *lastLoggedInUsername = [[NSUserDefaults standardUserDefaults] stringForKey:kSettingUsername];
    if (lastLoggedInUsername) {
        [self setCurrentUserWithUsername:lastLoggedInUsername];
    }
}

- (NSString *)getLastMessageRequestDateForCurrentUser {

    // error handling here is overly simplistic, but avoids crashes by at least returning somewhat sane values
    NSString *key = [NSString stringWithFormat:kSettingLastMessageRequestedDateTemplate, self.loggedInUsername ?: @"none"];
    NSString *lastMessageRequestedDateForCurrentUser = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return lastMessageRequestedDateForCurrentUser ?: @"0";
}

- (void)clearCurrentUser {
    
    _isLoggedIn = NO;
    _loggedInUsername = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettingUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.localMessages = nil;
}

- (void)setCurrentUserWithUsername:(NSString *)username {
    
    _isLoggedIn = YES;
    _loggedInUsername = username;
    
    // save for autologin
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kSettingUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadLocalMessages];
}

- (void)loadLocalMessages {
    
    if (!self.localMessages) {
        self.localMessages = [[NSMutableArray alloc] init];
    } else {
        [self.localMessages removeAllObjects];
    }
    
    NSString *localMessagesFile = [TWGeneralUtilities localMessagesFilePathForUsername:self.loggedInUsername];
    NSData *json = [NSData dataWithContentsOfFile:localMessagesFile];
    if (json) {
        NSError *error = nil;
        NSArray *temp = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.localMessages addObject:obj];
        }];
    }
}

- (void)saveLocalMessages {
    
    NSString *localMessagesFile = [TWGeneralUtilities localMessagesFilePathForUsername:self.loggedInUsername];
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self.localMessages options:kNilOptions error:&error];
    if (!error) {
        [json writeToFile:localMessagesFile atomically:YES];
    }
}

- (void)mergeNewMessages:(NSArray *)newMessages {
    
    // looping backwards, add each new object onto the local objects array at the head of the array
    [[[newMessages reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.localMessages insertObject:obj atIndex:0];
    }];
    
    NSDictionary *message = [self.localMessages firstObject]; // this is the newest message
    NSString *newestMessageTimestamp = [message valueForKey:@"ts"];
    [self setLastMessageRequestDateForCurrentUser:newestMessageTimestamp];
    
    [self saveLocalMessages];
}

#pragma mark - Singleton Methods
+ (TWUserManager *)shared {
    static TWUserManager *_sharedInstance;
    if(!_sharedInstance) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self shared];
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}
#endif

@end
