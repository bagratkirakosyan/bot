//
//  AppDelegate.m
//  Bot
//
//  Created by Bagrat Kirakosian on 10/27/16.
//  Copyright © 2016 PicsArt. All rights reserved.
//

#import "AppDelegate.h"
#import "Networking.h"
#import "RecorderViewController.h"
#import "ChatViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ChatViewController new];
    [self.window makeKeyAndVisible];
    
    NSString *str=[[NSBundle mainBundle] pathForResource:@"passport" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:str];
    
    
    [[Networking sharedInstance] analyzeImage:fileData withCompletion:^(BOOL success, NSDictionary *result) {
        NSArray *captions = result[@"description"][@"captions"];
        NSString *description = captions[0][@"text"];
        description = [description stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[description substringToIndex:1] uppercaseString]];
        NSArray *tags = result[@"description"][@"tags"];
        NSString *tag = [tags componentsJoinedByString:@" #"];
        
        NSString *format;
        
        if (description.length && tag.length) {
            format = @"%@. #%@";
        } else {
            format = @"%@";
        }
        
        NSString *fullDescription = [NSString stringWithFormat:format, description, tag];
        NSLog(@"%@", fullDescription);
    }];
    
    
//    [[Networking sharedInstance] auth:nil withCompletion:^(BOOL success, NSString *result) {
//        [[Networking sharedInstance] analyzeAudio:fileData withCompletion:^(BOOL success, NSDictionary *result) {
//            
//        }];
//    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
