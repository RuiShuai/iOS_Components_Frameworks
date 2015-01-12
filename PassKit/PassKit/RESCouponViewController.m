//
//  RESCouponViewController.m
//  PassKit
//
//  Created by taotao on 15/1/10.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCouponViewController.h"

@interface RESCouponViewController ()

@end

@implementation RESCouponViewController

- (void)viewDidLoad {

    self.passFileName = @"Coupon";
    self.passTypeName = @"Coupon";
    self.passIdentifier = @"pass.explore-systems.icfpasstest.coupon";
    self.passSerialNum = @"12345";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
