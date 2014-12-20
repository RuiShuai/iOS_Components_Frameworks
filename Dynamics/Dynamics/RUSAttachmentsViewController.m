//
//  RUSAttachmentsViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSAttachmentsViewController.h"

@interface RUSAttachmentsViewController ()

@end

@implementation RUSAttachmentsViewController

@synthesize attachmentBehavior;

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
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[dragonImageView,frogImageView]];
    CGPoint frogCenter = CGPointMake(frogImageView.center.x, frogImageView.center.y);
    
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:dragonImageView attachedToAnchor:frogCenter];
    
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeBoundaries];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [animator addBehavior:collisionBehavior];
    [animator addBehavior:self.attachmentBehavior];
    
}


-(IBAction)handleAttachmentGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint gesturePoint = [gesture locationInView:self.view];
    frogImageView.center = gesturePoint;
    [self.attachmentBehavior setAnchorPoint:gesturePoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
