//
//  TweederTableViewCell.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweederTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)configureWithData:(NSDictionary *)data;

@end
