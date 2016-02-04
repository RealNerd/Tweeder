//
//  ViewController.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "ViewController.h"
#import "TweederTableViewCell.h"
#import "TWUserManager.h"

@interface ViewController ()
@property (nonatomic) BOOL hasAutoPresentedLoginSignup;
@end

@implementation ViewController

#pragma mark - View management methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.hasAutoPresentedLoginSignup = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self refreshControls];
    // if we're not currently logged in, and we haven't shown the login form yet, show the login form
    if (![TWUserManager shared].isLoggedIn) {
        if (!self.hasAutoPresentedLoginSignup) {
            self.hasAutoPresentedLoginSignup = YES;
            [self presentLoginSignup];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"loginSignupSegue"]) {
        ((LoginSignupViewController *)segue.destinationViewController).delegate = self;
    }
}

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweederTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweederCell"];
    [cell configureWithData:@{}];
    return cell;
}

#pragma mark - General VC methods
- (void)refreshControls {

    if (![TWUserManager shared].isLoggedIn) {
        [self.loginLogoutButton setTitle:@"Login"];
    } else {
        [self.loginLogoutButton setTitle:@"Logout"];
    }
}

- (void)presentLoginSignup {
    
    // be nice and defer this modal presentation in case we're still in viewdidappear
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf performSegueWithIdentifier:@"loginSignupSegue" sender:self];
    });
}

#pragma mark - User interaction methods (outlets)
- (IBAction)onLoginLogoutTouched:(id)sender {

    if ([TWUserManager shared].isLoggedIn) {
        [[TWUserManager shared] logout];
        [self refreshControls];
        [self presentLoginSignup];
    } else {
        [self presentLoginSignup];
    }
}

- (IBAction)onAddTouched:(id)sender {
    NSLog(@"Add Touched");
}

#pragma mark - LoginSignup delegate method
- (void)loginSignupComplete {
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf refreshControls];
    }];
}

@end
