//
//  RESGameControlViewController.h
//  CactusGame
//
//  Created by taotao on 15/1/23.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESGameCenterManager.h"

@interface RESGameControlViewController : UIViewController<GameCenterManagerDelegate,GKGameCenterControllerDelegate>

- (IBAction)play:(id)sender;
- (IBAction)leaderboards:(id)sender;
- (IBAction)achievements:(id)sender;

@end
