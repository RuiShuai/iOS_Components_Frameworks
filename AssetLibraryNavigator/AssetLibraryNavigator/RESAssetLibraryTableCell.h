//
//  RESAssetLibraryTableCell.h
//  AssetLibraryNavigator
//
//  Created by taotao on 15/1/6.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESAssetLibraryTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *assetGroupNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *assetGroupInfoLabel;

@property (strong, nonatomic) IBOutlet UIImageView *assetGroupImageView;

@end
