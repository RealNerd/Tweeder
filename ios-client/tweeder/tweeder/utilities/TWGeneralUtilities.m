//
//  TWGeneralUtilities.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "TWGeneralUtilities.h"
#import "NSString+TweederUtilities.h"

NSString * const kTweederErrorDomain    = @"com.vikingricks.tweeder.error";
NSString * const kMessagesDirectoryPath = @"com.vikingricks.tweeder.messages";
NSInteger  const kTweederInternalError  = 10042;

@implementation TWGeneralUtilities

+ (NSError *)createAppErrorWithMessage:(NSString *)errorMessage {
    
    return [NSError errorWithDomain:kTweederErrorDomain code:kTweederInternalError userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
}

+ (BOOL)isValidApiStringParameter:(NSString *)parameter {
    
    if ((!(parameter) || (id)(parameter) == [NSNull null])) {
        return NO;
    }
    if ([[parameter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+ (NSString *)localMessagesFilePathForUsername:(NSString *)username {
    
    NSString *messagesDirectory = [self localMessagesDirectory];
    return [messagesDirectory stringByAppendingPathComponent:[username md5]];
}

+ (NSString *)localMessagesDirectory {
    
    NSString *messagesDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    
    messagesDir = [messagesDir stringByAppendingPathComponent:kMessagesDirectoryPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:messagesDir isDirectory:NULL]) {
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:messagesDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            
            return nil;
        } else {
            // mark the directory as excluded from iCloud backups
            NSURL *url = [NSURL fileURLWithPath:messagesDir];
            if (![url setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error]) {
                
                return nil;
            }
        }
    }
    
    return messagesDir;
}

+ (NSDateFormatter *)displayDateFormatter {
    
    static NSDateFormatter *_displayDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _displayDateFormatter = [[NSDateFormatter alloc] init];
        [_displayDateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    });
    
    return _displayDateFormatter;
}

@end
