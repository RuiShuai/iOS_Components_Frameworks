//
//  RUSCollisionViewController.h
//  Dynamics 碰撞效果
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUSCollisionViewController : UIViewController<UICollisionBehaviorDelegate>

{
    IBOutlet UIImageView *dragonImageView;
    IBOutlet UIImageView *frogImageView;
    
    IBOutlet UILabel *collisionOneLabel;
    IBOutlet UILabel *collisionTwoLabel;
    
    UIDynamicAnimator *animator;
}


@end
