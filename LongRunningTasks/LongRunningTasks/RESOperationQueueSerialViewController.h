//
//  RESOperationQueueSerialViewController.h
//  LongRunningTasks
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESOperationQueueSerialViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *displayItems;
@property (nonatomic, strong) NSOperationQueue *processingQueue;

@end