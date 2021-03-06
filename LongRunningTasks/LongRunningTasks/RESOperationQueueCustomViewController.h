//
//  RESOperationQueueCustomViewController.h
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESCustomOperation.h"
@interface RESOperationQueueCustomViewController : UITableViewController<RESCustomOperationDelegate>

@property (nonatomic,strong) NSMutableArray *displayItems;
@property (nonatomic,strong) NSOperationQueue *processingQueue;
@property (strong, nonatomic) IBOutlet UIView *statusView;

- (IBAction)cancelButtonTouched:(id)sender;

@end
