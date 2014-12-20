//
//  RUSCollisionViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSCollisionViewController.h"

@interface RUSCollisionViewController ()

@end

@implementation RUSCollisionViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //init animator
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //init behavior
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[frogImageView,dragonImageView]];
    [gravityBehavior setGravityDirection:CGVectorMake(0.0f, 0.1f)];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[frogImageView,dragonImageView]];
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeEverything];
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
    
    //set delegate
    collisionBehavior.collisionDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - collision delegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if ([item isEqual:frogImageView]) {
        collisionOneLabel.text = @"Frog Collided";
    }
    if ([item isEqual:dragonImageView]) {
        collisionTwoLabel.text = @"Dragon Collided";
    }
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    //collision has ended contact
}



@end
