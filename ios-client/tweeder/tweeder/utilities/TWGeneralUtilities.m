//
//  TWGeneralUtilities.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "TWGeneralUtilities.h"

NSString * const kTweederErrorDomain   = @"com.vikingricks.tweeder.error";
NSInteger  const kTweederInternalError = 10042;

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

@end
