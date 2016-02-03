//
//  apiManagerUnitAndIntegrationTests.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TWApiManager.h"

@interface apiManagerUnitAndIntegrationTests : XCTestCase

@end

@implementation apiManagerUnitAndIntegrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBogusApiMethod {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWApiManager shared] apiRequest:@"bogusEndpoint" withMethod:@"GET" andParameters:nil success:^(id responseObject) {

        [postExp fulfill];
        XCTFail(@"Somehow this bogus endpoint returned a valid result.");
    } failure:^(NSUInteger httpResponseCode, NSError *error) {

        [postExp fulfill];
        XCTAssertEqual(httpResponseCode, 404, @"Bogus endpoint returned something other than a 404");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testDirectLogin {
    
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWApiManager shared] apiRequest:@"login" withMethod:@"POST" andParameters:@{@"username": @"blake", @"password": @"phxsuns"} success:^(id responseObject) {
        
        [postExp fulfill];
    } failure:^(NSUInteger httpResponseCode, NSError *error) {
        
        [postExp fulfill];
        XCTFail(@"Failed direct login case");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

@end
