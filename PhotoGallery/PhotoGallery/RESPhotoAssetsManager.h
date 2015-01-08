//
//  RESPhotoAssetsManager.h
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RESFetchAssetsDelegate.h"


@interface RESPhotoAssetsManager : NSObject

@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) NSMutableArray *assetGroupArray;
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;

@property (weak,nonatomic) id<RESFetchAssetsDelegate> delegate;

+(RESPhotoAssetsManager *)sharedManager;

-(void)setupAssetData;

@end
