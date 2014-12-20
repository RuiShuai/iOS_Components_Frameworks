//
//  RUSAppDelegate.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSAppDelegate.h"
#import "RUSViewController.h"

@implementation RUSAppDelegate

//启动
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[RUSViewController alloc] initWithNibName:@"RUSViewController" bundle:nil];
    navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

//将要激活
-(void)applicationWillResignActive:(UIApplication *)application
{
    
}

//进入后台
-(void)applicationDidEnterBackground:(UIApplication *)application
{
    
}
//将要进入前台
-(void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

//激活
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

//将要终止
-(void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
