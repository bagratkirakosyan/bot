//
//  Networking.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/28/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "Networking.h"

@implementation Networking

- (void)analyzeImage:(NSData *)image withCompletion:(void(^)(BOOL success, NSDictionary *result))completion {
    NSString *path = @"https://api.projectoxford.ai/vision/v1.0/analyze";
    NSArray *array = @[@"visualFeatures=Description,Tags",];
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
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        completion(YES, json);
    }] resume];
}

@end
