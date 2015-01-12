//
//  RESGenericViewController.m
//  PassKit
//
//  Created by taotao on 15/1/10.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESGenericViewController.h"

@interface RESGenericViewController ()

@end

@implementation RESGenericViewController

- (void)viewDidLoad {

    self.passFileName = @"Generic";
    self.passTypeName = @"Generic";
    self.passIdentifier = @"pass.explore-systems.icfpasstest.generic";
    self.passSerialNum = @"12345";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
