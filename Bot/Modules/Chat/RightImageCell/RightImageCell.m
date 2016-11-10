//
//  RightImageCell.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "RightImageCell.h"

@interface RightImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation RightImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = 20;
    self.photoImageView.layer.cornerRadius = 10;
}

- (void)setMessage:(ChatMessageData *)message {
    _message = message;
    
    self.photoImageView.image = message.image;
    
    if (message.bot) {
        self.profileImageView.image = [UIImage imageNamed:@"bot"];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"user"];
    }
}

@end
