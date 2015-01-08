//
//  RESFetchAssetsDelegate.h
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RESFetchAssetsDelegate <NSObject>

-(void)updateCollectionView:(UICollectionView *)collectionView withAssetGroupArray:(NSMutableArray *)assetGroupArray andAssetArray:(NSMutableArray *)assetArray withGroupEnumError:(NSError *)error;

@end
