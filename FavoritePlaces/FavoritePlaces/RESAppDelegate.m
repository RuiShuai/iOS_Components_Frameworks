//
//  AppDelegate.m
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAppDelegate.h"
#import "RESLocationManager.h"

//#define FIRSTRUN 1

#ifdef FIRSTRUN
#import "RESDateStarter.h"
#endif

@interface RESAppDelegate ()

@end

@implementation RESAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
#ifdef FIRSTRUN 
    //Prepopulate the database
    [RESDateStarter setupStarterData];
    NSLog(@"Finished prepopulating database.");
    //exit(EXIT_SUCCESS);
    
#endif
    
    if ([CLLocationManager locationServicesEnabled]) {
        RESLocationManager *appLocationManager = [RESLocationManager sharedLocationManager];
        //启动Location服务
        [appLocationManager.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location Services disabled.");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    RESLocationManager *appLocationManager = [RESLocationManager sharedLocationManager];
    //停止Location服务
    [appLocationManager.locationManager stopUpdatingLocation];
    
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
