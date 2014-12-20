//
//  RUSAppDelegate.h
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RUSViewController;

@interface RUSAppDelegate : UIResponder<UIApplicationDelegate>
{
    UINavigationController *navController;
}
@property (strong,nonatomic) UIWindow *window;
@property (strong,nonatomic) RUSViewController *viewController;


@end
