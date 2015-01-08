//
//  RESBasicFlowViewController.h
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESFetchAssetsDelegate.h"

@interface RESBasicFlowViewController : UICollectionViewController<RESFetchAssetsDelegate>

@property (nonatomic,strong) NSArray *assetArray;
@property (nonatomic,strong) NSArray *assetGroupArray;

- (IBAction)actionTouched:(id)sender;

@end
