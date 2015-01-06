//
//  RESAssetGroupViewController.h
//  AssetLibraryNavigator
//
//  Created by taotao on 15/1/6.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RESAssetGroupViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) NSURL *assetGroupURL;
@property (nonatomic,strong) NSString *assetGroupName;
@property (nonatomic,strong) ALAssetsLibrary *assetLibrary;
@property (strong, nonatomic) IBOutlet UITableView *assetDetailTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addButtonTouched:(id)sender;
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
