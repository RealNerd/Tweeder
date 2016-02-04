//
//  NewMessageViewController.h
//  tweeder
//
//  Created by Blake Schwendiman on 2/3/16.
//  Copyright © 2016 Viking Rick's, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMessageVCDelegate <NSObject>

- (void)newMessageComplete;

@end


@interface NewMessageViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) id <NewMessageVCDelegate> delegate;

@end
