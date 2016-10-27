//
//  Networking.h
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject

+ (instancetype)sharedInstance;

- (void)auth:(NSData *)image withCompletion:(void(^)(BOOL success, NSString *result))completion;

- (void)analyzeAudio:(NSData *)audio withCompletion:(void(^)(BOOL success, NSDictionary *result))completion;

- (void)analyzeImage:(NSData *)image withCompletion:(void(^)(BOOL success, NSDictionary *result))completion;

@end
