//
//  AppDelegate.h
//  Bluetooth_Messages
//
//  Created by taotao on 15/1/13.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface RESAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MCManager *mcManager;

@end

