//
//  RESStoreCardViewController.m
//  PassKit
//
//  Created by taotao on 15/1/10.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESStoreCardViewController.h"

@interface RESStoreCardViewController ()

@end

@implementation RESStoreCardViewController

- (void)viewDidLoad {

    self.passFileName = @"StoreCard";
    self.passTypeName = @"Store Card";
    self.passIdentifier = @"pass.explore-systems.icfpasstest.storecard";
    self.passSerialNum = @"12345";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
