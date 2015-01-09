//
//  AppDelegate.h
//  KeychainPlayground
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RESKeychainViewController;

@interface RESAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RESKeychainViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@end

