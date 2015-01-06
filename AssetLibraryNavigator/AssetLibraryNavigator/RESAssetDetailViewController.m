//
//  RESAssetDetailViewController.m
//  AssetLibraryNavigator
//
//  Created by taotao on 15/1/6.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESAssetDetailViewController.h"

@interface RESAssetDetailViewController ()

@end

@implementation RESAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.assetImageView setImage:self.assetImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.assetImageView = nil;
    self.assetImage = nil;
}


@end
