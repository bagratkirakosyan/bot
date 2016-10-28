//
//  Networking.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "Networking.h"
#import <UIKit/UIKit.h>

@interface Networking ()

@property (nonatomic) NSString *token;

@end

@implementation Networking

+ (instancetype)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)auth:(void(^)(NSString *result))completion {
    NSString *path = @"https://api.cognitive.microsoft.com/sts/v1.0/issueToken";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:path]];
    [request setValue:@"1de11006370a44f9b2f41e839c427316" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *stringData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSString *string = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
        self.token = string;
        completion(string);
    }] resume];
}

- (void)analyzeImage:(NSData *)image withCompletion:(void(^)(NSString *result))completion {
    NSString *path = @"https://api.projectoxford.ai/vision/v1.0/analyze";
    NSArray *array = @[@"visualFeatures=Description,Tags"];
    NSString *string = [array componentsJoinedByString:@"&"];
    path = [path stringByAppendingFormat:@"?%@", string];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:path]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"11e3dc198857490fa9f52273ff5979de" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [request setHTTPBody:image];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSArray *captions = json[@"description"][@"captions"];
        NSString *description = captions[0][@"text"];
        description = [description stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[description substringToIndex:1] uppercaseString]];
        NSArray *tags = json[@"description"][@"tags"];
        NSString *tag = [tags componentsJoinedByString:@" #"];
        
        NSString *format;
        
        if (description.length && tag.length) {
            format = @"%@. #%@";
        } else {
            format = @"%@";
        }
        
        NSString *fullDescription = [NSString stringWithFormat:format, description, tag];
        completion(fullDescription);
    }] resume];
}




- (void)analyzeAudio:(NSData *)audio withCompletion:(void(^)(NSDictionary *result))completion {
    NSString *UUID = [[NSUUID UUID] UUIDString];
    NSString *path = @"https://speech.platform.bing.com/recognize";
    NSArray *array = @[@"version=3.0",
                       [NSString stringWithFormat:@"requestid=%@", UUID],
                       @"appID=D4D52672-91D7-4C74-8AD8-42B1D98141A5",
                       @"format=json",
                       @"locale=en-US",
                       @"device.os=iPhone%20OS",
                       @"scenarios=ulm",
                       [NSString stringWithFormat:@"instanceid=%@", UUID]];
    NSString *string = [array componentsJoinedByString:@"&"];
    path = [path stringByAppendingFormat:@"?%@", string];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:path]];
    [request setValue:@"audio/wav; samplerate=16000" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"1de11006370a44f9b2f41e839c427316" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [request setHTTPBody:audio];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        completion(json);
    }] resume];
}

- (void)analyzeMessage:(NSString *)message withCompletion:(void (^)(NSDictionary *))completion {
    NSString *escapedMessage = [message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *path = @"https://api.projectoxford.ai/luis/v1/application";
    NSArray *array = @[@"id=d68f953e-dbff-4df4-ac67-bc9dda87231e",
                       @"subscription-key=29f0b4fc48ea485696d4d7615ea347ba",
                       [NSString stringWithFormat:@"q=%@", escapedMessage],
                       @"timezoneOffset=0.0"];
    NSString *string = [array componentsJoinedByString:@"&"];
    path = [path stringByAppendingFormat:@"?%@", string];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:path]];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"11e3dc198857490fa9f52273ff5979de" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
//    [request setHTTPBody:image];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSArray *intents = json[@"intents"];
        NSString *intent;
        CGFloat bestIntentScore = 0.6;
        
        for (NSDictionary *dic in intents) {
            CGFloat score = [dic[@"score"] floatValue];
            if (score > 0 && score <= 1 && score > bestIntentScore) {
                intent = dic[@"intent"];
                bestIntentScore = score;
            }
        }
        
        
        NSArray *entities = json[@"entities"];
        NSString *entity;
        CGFloat bestEntityScore = 0.6;
        
        for (NSDictionary *dic in entities) {
            CGFloat score = [dic[@"score"] floatValue];
            if (score > 0 && score <= 1 && score > bestEntityScore) {
                entity = dic[@"entity"];
                bestEntityScore = score;
            }
        }
        
        
        completion(@{@"action" : intent ?: @"",
                     @"type" : entity ?: @""});
    }] resume];
}


@end
