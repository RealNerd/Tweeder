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

#define kNoMessagesTemplate    NSLocalizedString(@"%@ hasn't posted any messages yet!", @"")
#define kNoMessagesNotLoggedIn NSLocalizedString(@"You must log in to see your messages.", @"")

@interface ViewController ()
@property (nonatomic)         BOOL              hasAutoPresentedLoginSignup;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ViewController

#pragma mark - View management methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.hasAutoPresentedLoginSignup = NO;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tweederTable addSubview:self.refreshControl];
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
    if ([segue.identifier isEqualToString:@"newMessageSegue"]) {
        ((NewMessageViewController *)segue.destinationViewController).delegate = self;
    }
}

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [TWUserManager shared].messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweederTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweederCell"];
    
    // this is somewhat of an unsafe assumption (that the indexPath.row will be in the bounds of the data)
    [cell configureWithData:[[TWUserManager shared].messages objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - General VC methods
- (void)refreshControls {

    if (![TWUserManager shared].isLoggedIn) {
        [self.loginLogoutButton setTitle:@"Login"];
        self.noMessagesLabel.text = kNoMessagesNotLoggedIn;
        self.tweederTable.hidden = YES;
    } else {
        [self.loginLogoutButton setTitle:@"Logout"];
        self.noMessagesLabel.text = [NSString stringWithFormat:kNoMessagesTemplate, [TWUserManager shared].loggedInUsername];
        self.tweederTable.hidden = ([TWUserManager shared].messages.count == 0);
    }
    self.addMessageButton.enabled = [TWUserManager shared].isLoggedIn;
}

- (void)refreshData {
    
    __weak typeof(self) weakSelf = self;
    [[TWUserManager shared] fetchNewMessagesForCurrentUserWithBlock:^(BOOL success, NSError *error) {
        
        [weakSelf.refreshControl endRefreshing];
        [weakSelf refreshControls];
        
        if ([TWUserManager shared].messages.count > 0) {
            [weakSelf.tweederTable reloadData];
        }
    }];
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

    [self performSegueWithIdentifier:@"newMessageSegue" sender:self];
}

#pragma mark - LoginSignup and NewMessage delegate methodx
- (void)loginSignupComplete {
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf refreshControls];
        [weakSelf refreshData];
    }];
}

- (void)newMessageComplete {
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf refreshControls];
        [weakSelf refreshData];
    }];
}

@end
