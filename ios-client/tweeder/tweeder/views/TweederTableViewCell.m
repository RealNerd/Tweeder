//
//  TweederTableViewCell.m
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import "TweederTableViewCell.h"

@implementation TweederTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithData:(NSDictionary *)data {
    
    self.usernameLabel.text = @"blake";
    self.dateLabel.text = @"5/12/15 12:22:31";
    self.messageLabel.text = @"Congratulations to Daisy Ridley on her nomination for Favorite Actress! Vote by tweeting #VoteDaisyRidley & #KCA";
}

@end
