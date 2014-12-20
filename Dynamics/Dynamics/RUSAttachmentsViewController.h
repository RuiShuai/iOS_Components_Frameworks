//
//  RUSAttachmentsViewController.h
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUSAttachmentsViewController : UIViewController
{
    IBOutlet UIImageView *dragonImageView;
    IBOutlet UIImageView *frogImageView;
    
    UIDynamicAnimator *animator;
}

@property (nonatomic,strong) UIAttachmentBehavior *attachmentBehavior;

@end
