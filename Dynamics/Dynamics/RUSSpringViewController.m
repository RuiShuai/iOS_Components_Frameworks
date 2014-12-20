//
//  RUSSpringViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSSpringViewController.h"

@interface RUSSpringViewController ()

@end

@implementation RUSSpringViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[dragonImageView,frogImageView]];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[dragonImageView]];
    
    CGPoint frogCenter = CGPointMake(frogImageView.center.x, frogImageView.center.y);
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:dragonImageView attachedToAnchor:frogCenter];
    [self.attachmentBehavior setFrequency:1.0f];
    [self.attachmentBehavior setDamping:0.1f];
    [self.attachmentBehavior setLength:100.0f];
    
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeBoundaries];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
    [animator addBehavior:self.attachmentBehavior];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(IBAction)handleAttachmentGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint gesturePoint = [gesture locationInView:self.view];
    [self.attachmentBehavior setAnchorPoint:gesturePoint];
    frogImageView.center = gesturePoint;
}


@end
