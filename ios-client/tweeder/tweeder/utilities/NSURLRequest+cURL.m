//
//  NSURLRequest+cURL.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/10/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "NSURLRequest+cURL.h"

@implementation NSURLRequest (cURL)

- (NSString *)cURLString {
    
    NSMutableString *curl = [NSMutableString stringWithFormat:@"curl -k --dump-header - --request %@", self.HTTPMethod];
    
    for (NSString *key in self.allHTTPHeaderFields.allKeys) {
        
        NSString *value = [self.allHTTPHeaderFields objectForKey:key];
        [curl appendFormat:@" -H '%@: %@'", key, value];
    }
    
    NSString *bodyDataString = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
    if (bodyDataString.length) {
        
        [curl appendFormat:@" --data '%@'", bodyDataString];
    }
    
    [curl appendFormat:@" '%@'", self.URL.absoluteString];
    
    return curl;
}

@end
