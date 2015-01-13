//
//  AppDelegate.m
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAppDelegate.h"

@interface RESAppDelegate ()

@end

@implementation RESAppDelegate


- (void)setupiCloud
{
    dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(background_queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *iCloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        if (iCloudURL != nil) {
            NSLog(@"iCloud URL is available");
        }else{
            NSLog(@"iCloud URL is not avaliable");
        }
    });
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    [self setupiCloud];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
