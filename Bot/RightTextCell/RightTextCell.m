//
//  RightTextCell.m
//  Bot
//
//  Created by Aram Sargsyan on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "RightTextCell.h"
#import "UIColor+BotColors.h"

@interface RightTextCell ()

@property (weak) IBOutlet UILabel *messageLabel;
@property (weak) IBOutlet UIImageView *profileImageView;
@property (weak) IBOutlet UIView *messageContainerView;

@end

@implementation RightTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = 20;
    self.messageContainerView.layer.borderWidth = 1;
    self.messageContainerView.layer.borderColor = [UIColor botBlue].CGColor;
    self.messageContainerView.layer.cornerRadius = 10;
}

- (void)setMessage:(ChatMessageData *)message {
    self.messageLabel.text = message.message;
    
    if (message.bot) {
        self.profileImageView.image = [UIImage imageNamed:@"bot"];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"user"];
    }
}

@end
