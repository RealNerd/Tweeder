//
//  TweederTableViewCell.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "TweederTableViewCell.h"
#import "TWUserManager.h"
#import "TWGeneralUtilities.h"

@implementation TweederTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithData:(NSDictionary *)data {
    
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", [TWUserManager shared].loggedInUsername];
    self.messageLabel.text = [data valueForKey:@"message"];
    
    NSNumber *timeStamp = [data valueForKey:@"ts"];
    NSDate   *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSDateFormatter *displayFormatter = [TWGeneralUtilities displayDateFormatter];
    self.dateLabel.text = [displayFormatter stringFromDate:date];
}

@end
