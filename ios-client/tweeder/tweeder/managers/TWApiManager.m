//
//  TWApiManager.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "TWApiManager.h"

NSString * const kBaseURL = @"http://hollyscorner.com/tweeder/api";

@interface TWApiManager()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation TWApiManager

#pragma mark - Public methods
- (NSURLSessionDataTask * )apiRequest:(NSString *)endpoint
                           withMethod:(NSString *)method
                        andParameters:(NSDictionary *)parameters
                              success:(void (^)(id responseObject))successBlock
                              failure:(void (^)(NSUInteger httpResponseCode, NSError *error)) failureBlock {

    NSError *error = nil;
    NSString *fullUrl = [[kBaseURL stringByAppendingPathComponent:endpoint] stringByAppendingPathExtension:@"php"];
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:fullUrl parameters:parameters error:&error];

    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } else {
            if (failureBlock) {
                NSUInteger statusCode = 0;
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    statusCode = ((NSHTTPURLResponse *)response).statusCode;
                }
                failureBlock(statusCode, error);
            }
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

#pragma mark - initialization methods
- (id)init {

    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}


#pragma mark - Singleton Methods

+ (TWApiManager *)shared {
    static TWApiManager *_sharedInstance;
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
