//
//  RESAssertLibraryViewController.h
//  AssetLibraryNavigator
//
//  Created by taotao on 15/1/6.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESAssetLibraryViewController : UITableViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *assetGroupTableView;
@property (nonatomic,strong) NSArray *assetGroupArray;
@property (nonatomic,strong) NSURL *selectedGroupURL;

-(void)setupAssetData;

@end
