//
//  ChatMessageData.m
//  Bot
//
//  Created by Aram Sargsyan on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "ChatMessageData.h"

@interface ChatMessageData ()



@end

@implementation ChatMessageData

- (instancetype)initWith:(NSString *)message bot:(BOOL)bot maxTextWidth:(CGFloat)maxTextWidth {
    self = [super init];
    if (self) {
        self.message = message;
        self.bot = bot;
        self.textSize = [message boundingRectWithSize:CGSizeMake(maxTextWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    }
    return self;
}


@end
