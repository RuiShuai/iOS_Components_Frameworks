//
//  AppDelegate.m
//  NotificationAPN
//
//  Created by taotao on 15/1/25.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAppDelegate.h"

@interface RESAppDelegate ()

@end

@implementation RESAppDelegate

#pragma mark - 
#pragma mark App life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //
    NSDictionary *notifi = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    
}

#pragma mark -
#pragma mark Notification received methods
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    if ([application applicationState] == UIApplicationStateActive)
    {
        NSLog(@"Received local notification - app active");
        
    }
    else
    {
        NSLog(@"Received local notification - from background");
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    if ([application applicationState] == UIApplicationStateActive)
    {
        NSLog(@"Received remote notification - app active");
    }
    else
    {
        NSLog(@"Received remote notification - from background");
    }
}

#pragma mark -
#pragma mark Push Notification registration delegate methods
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self setPushToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@",error);
}

@end
