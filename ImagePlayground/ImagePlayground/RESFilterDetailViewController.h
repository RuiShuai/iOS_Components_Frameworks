//
//  RESFilterDisplayViewController.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESStarterViewController.h"


@protocol RESFilterEditingDelegate <NSObject>

-(void)updateFilterAttribute:(NSString *)attributeKey withValue:(id)value;

@end

@interface RESFilterDetailViewController : UIViewController<RESFilterEditingDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) CIFilter *selectedFilter;
@property (weak,nonatomic) id<RESFilterProcessingDelegate> filterDelegate;

@property (strong, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) IBOutlet UILabel *filterName;

@property (strong, nonatomic) IBOutlet UIView *previewImageContainer;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;



@end
