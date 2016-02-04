//
//  LoginSignupViewController.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginSignupVCDelegate <NSObject>

- (void)loginSignupComplete;

@end

@interface LoginSignupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *primaryActionButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryActionButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) id <LoginSignupVCDelegate> delegate;

@end
