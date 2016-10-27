//
//  LeftTextCell.m
//  Bot
//
//  Created by Aram Sargsyan on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "LeftTextCell.h"
#import "UIColor+BotColors.h"

@interface LeftTextCell ()

@property (weak) IBOutlet UILabel *messageLabel;
@property (weak) IBOutlet UIImageView *profileImageView;
@property (weak) IBOutlet UIView *messageContainerView;

@end

@implementation LeftTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.image = [UIImage imageNamed:@"bot"];
    self.profileImageView.clipsToBounds = true;
    self.profileImageView.layer.cornerRadius = 20;
    
    self.messageContainerView.layer.borderWidth = 1;
    self.messageContainerView.layer.borderColor = [[UIColor botLightGray] CGColor];
    self.messageContainerView.layer.cornerRadius = 12.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
}

@end
