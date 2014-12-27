//
//  AppDelegate.m
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAppDelegate.h"
#import "RESMovieListViewController.h"

//#define FIRSTRUN 1

#ifdef FIRSTRUN
#import "RESDataStarter.h"
#endif

@interface RESAppDelegate ()

@end

@implementation RESAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
#ifdef FIRSTRUN
    //Prepopulate the database.
    [RESDataStarter setupStarterData];
    NSLog(@"Finished prepopulating database.");
    exit(EXIT_SUCCESS);
#endif

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
