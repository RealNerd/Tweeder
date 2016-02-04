//
//  NewMessageViewController.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "NewMessageViewController.h"
#import <IQKeyboardManager.h>
#import "TWUserManager.h"

@interface NewMessageViewController ()

@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 40.0;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    self.messageTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshControls];
    [self enableControls];
    
    self.messageTextView.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
    self.messageTextView.layer.borderWidth  = 1.0;
    self.messageTextView.layer.cornerRadius = 8.0;
}

- (void)refreshControls {
    
    self.messageTextView.text = @"";
    self.characterCountLabel.text = @"0 characters";
}

- (void)enableControls {
    
    NSUInteger textLength = self.messageTextView.text.length;
    self.postButton.enabled = (textLength > 0);
}

- (void)close {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(newMessageComplete)]) {
            [self.delegate newMessageComplete];
        }
    }
}

- (void)displayError:(NSError *)error {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d %@", textView.text.length, (textView.text.length == 1 ? @"character" : @"characters")];
    [self enableControls];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onPostTouched:(id)sender {

    NSString *message  = self.messageTextView.text;
    
    __weak typeof(self) weakSelf = self;
    [[TWUserManager shared] postNewMessageForCurrentUser:message block:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf close];
        } else {
            [weakSelf displayError:error];
        }
    }];
}

- (IBAction)onCloseTouched:(id)sender {

    [self close];
}

@end
