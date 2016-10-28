//
//  ChatMessageData.h
//  Bot
//
//  Created by Aram Sargsyan on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatMessageData : NSObject

@property UIImage *image;
@property NSString *message;
@property BOOL bot;
@property CGSize textSize;

- (instancetype)initWith:(NSString *)message image:(UIImage *)image bot:(BOOL)bot maxTextWidth:(CGFloat)maxTextWidth;

@end
