//
//  RUSForceViewController.h
//  Dynamics  推力效果
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUSForceViewController : UIViewController
{
    IBOutlet UIImageView *dragonImageView;
    UIDynamicAnimator *animator;
}

@property (nonatomic,strong) UIPushBehavior *pushBehavior;

@end
