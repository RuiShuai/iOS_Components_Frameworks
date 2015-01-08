//
//  RESPhotoAssetsManager.m
//  PhotoGallery
//
//  Created by taotao on 15/1/7.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESPhotoAssetsManager.h"

@implementation RESPhotoAssetsManager

static RESPhotoAssetsManager *_sharedManager = nil;

+(RESPhotoAssetsManager *)sharedManager
{
    if (_sharedManager != nil) {
        return _sharedManager;
    }
    static dispatch_once_t once;
    dispatch_once(&once,^{
        _sharedManager = [[RESPhotoAssetsManager alloc] init];
        [_sharedManager assetGroupArray];
        [_sharedManager assetArray];
        [_sharedManager delegate];
    });
    return _sharedManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        _assetArray = [[NSMutableArray alloc]init];
        _assetGroupArray = [[NSMutableArray alloc]init];
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [self setupAssetData];
    }
    
    return self;
}

-(void)setupAssetData
{
    
    //enumerateAssetGroupsBlock
    void (^enumerateAssetGroupsBlock)(ALAssetsGroup*,BOOL*) = ^(ALAssetsGroup* group,BOOL* stop){
        if (group) {
            NSString *sectionTitle = [NSString stringWithFormat:@"%@ - %d",[group valueForProperty:ALAssetsGroupPropertyName],[group numberOfAssets]];
            
            /*
             NSInteger number = (NSInteger)[group numberOfAssets];
             NSDictionary *groupDict = @{
             @"sectionTitle":sectionTitle,
             @"numberOfAssets":@(number)
             };
             */
            if ([group numberOfAssets]>0) {
                [self.assetGroupArray addObject:sectionTitle];
                
                //2.遍历Group->Assets
                [self enumerateGroupAssetsForGroup:group];
            }
            
        }else{
            //遍历完成之后,更新视图数据
            //[self.collectionView reloadData];
            [self.delegate updateCollectionView:nil withAssetGroupArray:self.assetGroupArray andAssetArray:self.assetArray withGroupEnumError:nil];
            //NSLog(@"assetGroupArray:%d,assetArray:%d",[self.assetGroupArray count],[self.assetArray count]);

        }
    };
    
    
    //assetGroupEnumErrorBlock
    void (^assetGroupEnumErrroBlock)(NSError*) = ^(NSError *error){
        NSString *msgError = @"Cannot access asset library groups. \n"
        "Visit Privacy | Photos in Settings.app \n"
        "to restore permission.";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:msgError forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"FetchAssets" code:0 userInfo:userInfo];
        
        [self.delegate updateCollectionView:nil withAssetGroupArray:nil andAssetArray:nil withGroupEnumError:err];

    };
    
    //1.遍历Library->Groups
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:enumerateAssetGroupsBlock
                                    failureBlock:assetGroupEnumErrroBlock];
}

-(void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group
{
    //标记
    NSInteger lastIndex = [group numberOfAssets] - 1;
    
    __block NSMutableArray *groupAssetArray = [[NSMutableArray alloc]init];
    //回调Block
    void (^addAsset)(ALAsset*,NSUInteger,BOOL*) = ^(ALAsset* result,NSUInteger index,BOOL *stop){
        if (result != nil) {
            [groupAssetArray addObject:result];
        }
        
        if (index == lastIndex) {
            [self.assetArray addObject:groupAssetArray];
        }
        
    };
    //遍历Group->Assets
    [group enumerateAssetsUsingBlock:addAsset];
}


@end
