//
//  ViewController.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginSignupViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoginSignupVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweederTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginLogoutButton;

@end

