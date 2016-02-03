//
//  userManagerTestCase.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TWUserManager.h"

@interface userManagerTestCase : XCTestCase

@end

@implementation userManagerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateAccountWithBogusPasswordNil {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] createNewUserAccount:@"testAccount" password:nil block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Nil password should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testCreateAccountWithBogusPasswordEmpty {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] createNewUserAccount:@"testAccount" password:@"" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Empty password should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testCreateAccountWithBogusUsernameNil {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] createNewUserAccount:nil password:@"foo" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Nil username should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testCreateAccountWithBogusUsernameEmpty {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] createNewUserAccount:@"" password:@"foo" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Empty username should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testCreatePreExistingTestAccount {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] createNewUserAccount:@"testAccount" password:@"testAccountPassword" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"This test should fail because the test account is already created on the server.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLoginWithBogusPasswordNil {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:@"testAccount" password:nil block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Nil password should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLoginWithBogusPasswordEmpty {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:@"testAccount" password:@"" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Empty password should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLoginWithBogusUsernameNil {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:nil password:@"foo" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Nil username should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLoginWithBogusUsernameEmpty {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:@"" password:@"foo" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Empty username should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLoginWithValidUsernameAndBogusPassword {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:@"testAccount" password:@"foo" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        XCTAssertFalse(success, @"Bad password. This should not have passed.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLoginWithValidCredentials {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:@"testAccount" password:@"testAccountPassword" block:^(BOOL success, NSError *error) {
        
        [postExp fulfill];
        NSString *currentUser = [TWUserManager shared].loggedInUsername;
        XCTAssertTrue([currentUser isEqualToString:@"testAccount"], @"This should have worked.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testFetchMessagesWithNoCurrentUser {
    
    [[TWUserManager shared] logout];
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] fetchNewMessagesForCurrentUserWithBlock:^(NSArray *newMessages, NSError *error) {

        [postExp fulfill];
        XCTAssertNotNil(error, @"This should have generated an error.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testFetchMessagesWithCurrentUser {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    [[TWUserManager shared] loginToUserAccount:@"testAccount" password:@"testAccountPassword" block:^(BOOL success, NSError *error) {
        
        [[TWUserManager shared] fetchNewMessagesForCurrentUserWithBlock:^(NSArray *newMessages, NSError *error) {
            
            [postExp fulfill];
            XCTAssertNil(error, @"Unexpected error fetching messages for logged-in user.");
        }];
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testPostMessageWithNoCurrentUser {
    
    [[TWUserManager shared] logout];
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    NSString *newMessage = [NSString stringWithFormat:@"New message (%@)", stringFromDate];
    
    [[TWUserManager shared] postNewMessageForCurrentUser:newMessage block:^(BOOL success, NSError *error) {

        [postExp fulfill];
        XCTAssertNotNil(error, @"This should have generated an error.");
    }];
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testPostMessageWithCurrentUser {
    
    XCTestExpectation *postExp = [self expectationWithDescription:@"API method timeout"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    NSString *newMessage = [NSString stringWithFormat:@"New message (%@)", stringFromDate];
    
    [[TWUserManager shared] loginToUserAccount:@"testAccount" password:@"testAccountPassword" block:^(BOOL success, NSError *error) {
        
        [[TWUserManager shared] postNewMessageForCurrentUser:newMessage block:^(BOOL success, NSError *error) {
            
            [postExp fulfill];
            XCTAssertNil(error, @"Unexpected error posting message.");
        }];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

@end
