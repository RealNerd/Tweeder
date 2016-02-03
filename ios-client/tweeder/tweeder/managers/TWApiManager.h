//
//  TWApiManager.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface TWApiManager : NSObject

+ (TWApiManager *)shared;
- (NSURLSessionDataTask *)apiRequest:(NSString *)endpoint
                          withMethod:(NSString *)method
                       andParameters:(NSDictionary *)parameters
                             success:(void (^)(id responseObject))successBlock
                             failure:(void (^)(NSUInteger httpResponseCode, NSError *error)) failureBlock;

@end
