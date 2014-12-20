//
//  RUSPropertiesViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSPropertiesViewController.h"

@interface RUSPropertiesViewController ()

@end

@implementation RUSPropertiesViewController

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
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[dragonImageView,frogImageView]];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[dragonImageView,frogImageView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    UIDynamicItemBehavior *propertiesBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[frogImageView]];
    propertiesBehavior.elasticity = 1.0f;
    propertiesBehavior.allowsRotation = NO;
    propertiesBehavior.angularResistance = 0.0f;
    propertiesBehavior.density = 3.0f;
    propertiesBehavior.friction = 0.5f;
    propertiesBehavior.resistance = 0.5f;
    
    [animator addBehavior:propertiesBehavior];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
}




@end
