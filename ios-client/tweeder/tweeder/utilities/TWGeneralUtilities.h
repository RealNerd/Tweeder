//
//  TWGeneralUtilities.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWGeneralUtilities : NSObject

+ (NSError *)createAppErrorWithMessage:(NSString *)errorMessage;
+ (BOOL)isValidApiStringParameter:(NSString *)parameter;

@end
