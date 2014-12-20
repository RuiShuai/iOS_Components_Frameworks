//
//  RUSForceViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSForceViewController.h"

@interface RUSForceViewController ()

@end

@implementation RUSForceViewController

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
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[dragonImageView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collisionBehavior];
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[dragonImageView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.angle = 0.0;
    pushBehavior.magnitude = 0.0;
    
    self.pushBehavior = pushBehavior;
    [animator addBehavior:self.pushBehavior];
}

- (IBAction)handlePushGesture:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.view];
    CGPoint origin = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGFloat distance = sqrtf(powf(point.x-origin.x, 2.0)+powf(point.y-origin.y, 2.0));
    CGFloat angle = atan2(point.y-origin.y,point.x-origin.x);
    distance = MIN(distance, 100.0);
    
    [self.pushBehavior setMagnitude:distance/100.0];
    [self.pushBehavior setAngle:angle];
    
    [self.pushBehavior setActive:TRUE];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
