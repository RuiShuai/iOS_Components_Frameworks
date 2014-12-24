//
//  AppDelegate.m
//  FavoritePlaces
//
//  Created by taotao on 14/12/22.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSAppDelegate.h"
#import "RUSLocationManager.h"
//#define FIRSTRUN 1

#ifdef FIRSTRUN
#import "RUSDateStarter.h"
#endif

@interface RUSAppDelegate ()

@end

@implementation RUSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
#ifdef FIRSTRUN
    //Prepopulate the database
    [RUSDateStarter setupStarterData];
    NSLog(@"Finished prepopulating database.");
    //exit(EXIT_SUCCESS);
    
#endif
    
    if ([CLLocationManager locationServicesEnabled]) {
        RUSLocationManager *appLocationManager = [RUSLocationManager sharedLocationManager];
        //启动Location服务
        [appLocationManager.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location Services disabled.");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    RUSLocationManager *appLocationManager = [RUSLocationManager sharedLocationManager];
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
