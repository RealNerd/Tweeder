//
//  LoginSignupViewController.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "LoginSignupViewController.h"
#import <IQKeyboardManager.h>
#import "TWUserManager.h"

// User displayed strings
#define kLoginTitle                 NSLocalizedString(@"Login", @"")
#define kSignupTitle                NSLocalizedString(@"Sign Up", @"")
#define kLoginPrimaryActionText     NSLocalizedString(@"Login", @"")
#define kSignupPrimaryActionText    NSLocalizedString(@"Sign Up", @"")
#define kLoginSecondaryActionText   NSLocalizedString(@"I need to Sign Up", @"")
#define kSignupSecondaryActionText  NSLocalizedString(@"Oops, I really just want to login", @"")

#define kSignupFailure              NSLocalizedString(@"There was an error signing you up. Try using a different username.", @"")
#define kLoginFailure               NSLocalizedString(@"There was an error logging you in. Double check your username and password and try again.", @"")


@interface LoginSignupViewController ()
@property (atomic)            BOOL         showingLoginView;

@end

@implementation LoginSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showingLoginView = YES;
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 80.0;
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshControls];
    [self enablePrimaryActionButton];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

#pragma mark - General VC methods
- (void)refreshControls {
    
    if (self.showingLoginView) {
        self.titleLabel.text = kLoginTitle;
        [self.primaryActionButton setTitle:kLoginPrimaryActionText forState:UIControlStateNormal];
        [self.secondaryActionButton setTitle:kLoginSecondaryActionText forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = kSignupTitle;
        [self.primaryActionButton setTitle:kSignupPrimaryActionText forState:UIControlStateNormal];
        [self.secondaryActionButton setTitle:kSignupSecondaryActionText forState:UIControlStateNormal];
    }
}

- (void)enablePrimaryActionButton {
    
    self.primaryActionButton.enabled = ((self.usernameTextField.text.length > 0) && (self.passwordTextField.text.length > 0));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return NO;
}

- (void)close {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(loginSignupComplete)]) {
            [self.delegate loginSignupComplete];
        }
    }
}

- (void)displayError:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - User interaction (IBAction)
- (IBAction)onPrimaryActionTouched:(id)sender {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    __weak typeof(self) weakSelf = self;
    if (self.showingLoginView) {
        [[TWUserManager shared] loginToUserAccount:username password:password block:^(BOOL success, NSError *error) {
            
            if (success) {
                [weakSelf close];
            } else {
                [weakSelf displayError:kLoginFailure];
            }
        }];
    } else {
        [[TWUserManager shared] createNewUserAccount:username password:password block:^(BOOL success, NSError *error) {
            
            if (success) {
                [weakSelf close];
            } else {
                [weakSelf displayError:kSignupFailure];
            }
        }];
    }
}

- (IBAction)onSecondaryActionTouched:(id)sender {
    
    self.showingLoginView = !self.showingLoginView;
    [self refreshControls];
}

- (IBAction)onTextFieldChanged:(id)sender {

    [self enablePrimaryActionButton];
}

- (IBAction)onCloseTouched:(id)sender {

    [self close];
}

@end
