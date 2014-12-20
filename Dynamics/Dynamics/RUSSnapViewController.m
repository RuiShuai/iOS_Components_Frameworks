//
//  RUSSnapViewController.m
//  Dynamics
//
//  Created by taotao on 14/12/20.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RUSSnapViewController.h"

@interface RUSSnapViewController ()

@end

@implementation RUSSnapViewController

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
    
}



- (IBAction)handleSnapGesture:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.view];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UISnapBehavior* snapBehavior = [[UISnapBehavior alloc]initWithItem:frogImageView snapToPoint:point];
    snapBehavior.damping = 0.75f;
    [animator addBehavior:snapBehavior];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
