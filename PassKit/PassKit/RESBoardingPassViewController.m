//
//  RESBoardingPassViewController.m
//  PassKit
//
//  Created by taotao on 15/1/10.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESBoardingPassViewController.h"

@interface RESBoardingPassViewController ()

@end

@implementation RESBoardingPassViewController

- (void)viewDidLoad {

    self.passFileName = @"BoardingPass";
    self.passTypeName = @"Boarding Pass";
    self.passIdentifier = @"pass.explore-systems.icfpasstest.boardingpass";
    self.passSerialNum = @"12345";
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
