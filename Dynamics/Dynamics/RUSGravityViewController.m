//
//  RUSGravityViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSGravityViewController.h"

@interface RUSGravityViewController ()

@end

@implementation RUSGravityViewController

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
    //init animator
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    //init behavior
    UIGravityBehavior *gravityBehaivor =[[UIGravityBehavior alloc]initWithItems:@[frogImageView]];
    [gravityBehaivor setGravityDirection:CGVectorMake(0.0f, 0.1f)];
    [animator addBehavior:gravityBehaivor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
