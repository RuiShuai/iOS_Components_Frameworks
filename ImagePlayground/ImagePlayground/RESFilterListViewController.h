//
//  RESFilterListViewController.h
//  ImagePlayground
//
//  Created by taotao on 14/12/31.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESStarterViewController.h"

@interface RESFilterListViewController : UITableViewController

@property (strong,nonatomic) NSString *selectedCategory;
@property (nonatomic,weak) id<RESFilterProcessingDelegate> filterDelegate;

@end
