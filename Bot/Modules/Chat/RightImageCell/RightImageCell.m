//
//  RightImageCell.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "RightImageCell.h"

@implementation RightImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = 20;
    self.photoImageView.layer.cornerRadius = 10;
}

- (void)setMessage:(ChatMessageData *)message {
    self.photoImageView.image = message.image;
    
    if (message.bot) {
        self.profileImageView.image = [UIImage imageNamed:@"bot"];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"user"];
    }
}

@end
