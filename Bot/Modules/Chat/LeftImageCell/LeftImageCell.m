//
//  LeftImageCell.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "LeftImageCell.h"

@interface LeftImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

@implementation LeftImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = 20;
    self.photoImageView.layer.cornerRadius = 10;
}

- (void)setMessage:(ChatMessageData *)message {
    _message = message;
    
    self.photoImageView.image = message.image;
    
    CGFloat maxWidth = self.contentView.frame.size.width - (55 + 60);
    CGFloat imageWidth = message.image.size.width;
    CGFloat width = MIN(imageWidth, maxWidth);
    CGFloat height = message.image.size.height * (width / imageWidth);
    
    self.width.constant = width;
    self.height.constant = height;
    
    if (message.bot) {
        self.profileImageView.image = [UIImage imageNamed:@"bot"];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"user"];
    }
}

@end
