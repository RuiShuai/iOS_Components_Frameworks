//
//  RESExclusionPathViewController.m
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESExclusionPathViewController.h"

@interface RESExclusionPathViewController ()

@end

@implementation RESExclusionPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(110, 100, 100, 102)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 110, 100, 102)];
    [imageView setImage:[UIImage imageNamed:@"DF.png"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self.textView addSubview:imageView];
    
    self.textView.textContainer.exclusionPaths = @[circle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
