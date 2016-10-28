//
//  LeftImageCell.h
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageData.h"

@interface LeftImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak) IBOutlet UIImageView *profileImageView;

- (void)setMessage:(ChatMessageData *)message;

@end
